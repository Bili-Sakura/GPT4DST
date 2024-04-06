# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
from scrapy.exceptions import DropItem


class DstWikiPipeline:
    def process_item(self, item, spider):
        return item


class FandomPipeline(object):
    def process_item(self, item, spider):       
        if any(discard in item['source'] for discard in
                   ['?', 'File:', 'Template:', 'Talk:', '#', 'Special:', 'Message_Wall:', 'User:', 'Help:',
                    'User_blog:', 'Board_Thread:', 'Thread:']):
            raise DropItem("Drop %s" % item)
        else:
            return item