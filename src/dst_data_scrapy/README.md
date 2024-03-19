# DST Data Scrapy README

## How To Run

Install Scrapy:
`pip install scrapy`

Run:
`time scrapy crawl fandom -o output.json` in `dst_wiki` folder,
which equals to run `scrapy crawl fandom -o output.json` and calculate the total time.

Calculate the number of lines of output file:
`wc -l output.json`

## CHANGELOG

### 2024.03.12

1. 重构了 fandom scrapy 的代码，新版的代码有以下更新：
    - 使用了 scrapy 自带的去重，通过重写 `start_requests` 函数实现了 start_urls 里面的链接也加入去重（scrapy 默认的 `start_requests` 中 `dont_filter=True`），从而省去了原来自己实现的去重逻辑
    - 使用 scrapy rules 来实现了对 URL 规则的筛选，省去了在 `parse()` 中判断的部分
    - 使用 scrapy rules 中 `follow=True` 来实现递归爬取，省去了手动收集页面链接并发起请求的部分
    - 在 `pipelines.py` 中新建了 `FandomPipeline` 类并在 `settings.py` 中启用，用于处理 Request URL 符合 URL 规则，但是重定向之后的 Response URL 不符合规则的情况，对 Item 进行筛选
2. 更新了数据清洗的规则：
    - 去掉所有标签为 table 的部分
    - 只提取 class="page__main" 中的内容
    - 去掉页面上“选择不同语言”部分的文本
    - 去掉页面上“Edit”、“View Source”以及下拉栏的文本
    - References[], Gameplay Mechanics, Categories Categories这三个部分在最后且都不需要，遇到了就直接去掉
3. 最终统计结果：得到的数据一共有 2519 条，