import re
import scrapy
from bs4 import BeautifulSoup

from scrapy.spiders import Rule, CrawlSpider
from scrapy.linkextractors import LinkExtractor
from dst_wiki.items import DstWikiItem
from urllib.parse import urlparse


class FandomSpider(CrawlSpider):
    name = "fandom"
    allowed_domains = ["dontstarve.fandom.com"]
    start_urls = ["https://dontstarve.fandom.com/wiki/Don%27t_Starve_Together", "https://dontstarve.fandom.com/wiki/Don%27t_Starve", "https://dontstarve.fandom.com/wiki/Don%27t_Starve_Wiki"]

    # 这里用 dontstarve.fandom.com/wiki/ 而不是 /wiki/ 是为了只留下英语网页
    # 在 fandom 中，其他语言，例如中文，url 的形式会是 dontstarve.fandom.com/zh/wiki/ 这样加在 /wiki/ 前面
    rules = (
        Rule(LinkExtractor(allow=(r'dontstarve.fandom.com/wiki/',), deny=('\?', 'file:', 'File:', 'Template:', 'Talk:', '#', 'Special:', 'Message_Wall:', 'User:', 'Help:',
                    'User_blog:', 'Board_Thread:', 'Thread:', 'comment', 'Gallery')), callback='parse', follow=True),
    )

    # scrapy 自带去重，但是默认对 start_urls 里面的链接不去重
    # 重写 start_requests 设置 dont_filter=False 以使用自带去重
    def start_requests(self):
        for url in self.start_urls:
            yield scrapy.Request(url, dont_filter=False)

    def parse(self, response):
        print(response.url)

        # 提取文本内容并处理
        soup = BeautifulSoup(response.text, 'html.parser')
        # 去掉所有的table标签
        for table in soup.find_all('table'):
            table.decompose()
        # 只提取 class="page__main" 中的内容
        page_main = soup.find(class_="page__main")
        if page_main:
            text = page_main.get_text()
        else:
            text = ""
        text = self.clean_text(text)

        # 提取文件名
        filename = urlparse(response.url).path.split('/')[-1]

        item = DstWikiItem()
        item['source'] = response.url
        item['text'] = text
        item['filename'] = filename
        # 创建item并返回
        yield item

    def clean_text(self, text):
        text = text.replace('\n', ' ').replace('\t', ' ')
        text = re.sub('\u200E', '', text)
        text = ' '.join(text.split())

        # 语言一共有 English Deutsch Español Français Italiano 日本語 Polski Português Русский Tiếng Việt 中文
        # 除了 English 之外，其他语言名称都不太可能出现在正文中，直接去掉
        language_list = ["Deutsch", "Español", "Français", "Italiano", "日本語", "Polski", 
                         "Português", "Русский", "Tiếng", "Việt", "中文"]
        for each_language in language_list:
            text = text.replace(each_language, '')

        # 去掉 < Guides 导航字段
        text = text.replace('< Guides', '')

        # 去掉 Edit Edit source View history Talk (0) 这个选项字段
        start_str = "Edit Edit source"
        end_str = ")"
        text = self.delete_between(text, start_str, end_str)

        # 去掉 View source View history Talk (0) 这个选项字段
        start_str = "View source"
        end_str = ")"
        text = self.delete_between(text, start_str, end_str)

        # 遇到了就删到结尾
        del_till_end_list = [
            "References[]", "Gameplay Mechanics", "Categories Categories:"
        ]
        for each in del_till_end_list:
            text = self.delelte_till_end(text, each)

        return text.strip()
    
    def delete_between(self, text, start_str, end_str):
        start_index = text.find(start_str)
        end_index = text.find(end_str) + len(end_str)

        if start_index != -1 and end_index != -1:
            modified_text = text[:start_index] + text[end_index:]
            text = modified_text
        return text
    
    def delelte_till_end(self, text, start_str):
        start_index = text.find(start_str)
        if start_index != -1:
            text = text[:start_index]
        return text



