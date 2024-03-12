import re
import scrapy
from bs4 import BeautifulSoup

from scrapy.spiders import Rule, CrawlSpider
from scrapy.linkextractors import LinkExtractor
from dst_wiki.items import DstWikiItem
from urllib.parse import urlparse


class FandomSpider(scrapy.Spider):
    name = "fandom"
    allowed_domains = ["dontstarve.fandom.com"]
    start_urls = ["https://dontstarve.fandom.com/wiki/Don%27t_Starve_Together", "https://dontstarve.fandom.com/wiki/Don%27t_Starve"]
    crawled_urls = set()

    rules = (
        Rule(
            LinkExtractor(allow=('/wiki/',)), callback='parse', follow=True),
    )

    visited_urls = set()  # 假设这是全局的或者在类中定义的集合

    def parse(self, response, *args, **kwargs):
        # 检查是否已经爬取过这个链接
        if self.already_visited(response.url):
            return

        # 递归处理链接
        for link in response.css('a::attr(href)').getall():
            absolute_link = response.urljoin(link)
            if not absolute_link.startswith("https://dontstarve.fandom.com/wiki/"):
                continue
            # 检查链接是否应该被丢弃
            if any(discard in absolute_link for discard in
                   ['?', 'File:', 'Template:', 'Talk:', '#', 'Special:', 'Message_Wall:', 'User:', 'Help:',
                    'User_blog:', 'Board_Thread:', 'Thread:']):
                continue
            print("absolute link:", absolute_link)
            # 递归跟进链接
            # yield response.follow(absolute_link, self.parse)
            yield scrapy.Request(absolute_link, callback=self.parse)

        # 提取文本内容并处理
        soup = BeautifulSoup(response.text, 'html.parser')
        text = soup.get_text()
        text = self.clean_text(text)

        # 提取文件名
        filename = urlparse(response.url).path.split('/')[-1]

        item = DstWikiItem()
        item['source'] = response.url
        item['text'] = text
        item['filename'] = filename
        # 创建item并返回
        yield item

    def already_visited(self, url):
        # 这里可以实现去重逻辑，例如使用集合存储已经访问过的URLs
        if url in self.visited_urls:
            return True
        self.visited_urls.add(url)
        return False

    def clean_text(self, text):
        text = text.replace('\n', ' ').replace('\t', ' ')
        text = re.sub('\u200E', '', text)
        text = ' '.join(text.split())
        # 去掉重复结尾
        text = text.replace(
            "Community content is available under CC-BY-SA unless otherwise noted. More Fandoms Fantasy Horror Don't Starve Advertisement Fan Feed More Don't Starve Wiki 1 Characters 2 Don't Starve Together 3 Crock Pot Explore properties Fandom Muthead Fanatical Follow Us Overview What is Fandom? About Careers Press Contact Terms of Use Privacy Policy Global Sitemap Local Sitemap Community Community Central Support Help Do Not Sell or Share My Personal Information Advertise Media Kit Contact Fandom Apps Take your favorite fandoms with you and never miss a beat. Don't Starve Wiki is a FANDOM Games Community. View Mobile Site Follow on IG TikTok Join Fan Lab",
            "")
        # 去掉重复开头
        start_str = "| Don't Starve Wiki |"
        end_str = "View history Talk (0)"

        start_index = text.find(start_str)
        end_index = text.find(end_str) + len(end_str)

        if start_index != -1 and end_index != -1:
            modified_text = text[:start_index] + text[end_index:]
            text = modified_text
        else:
            # 起始字符串或结束字符串未找到
            pass
        return text.strip()



