
import scrapy
from scrapy.crawler import CrawlerProcess

# Define the URL to scrape
url = 'http://quotes.toscrape.com' # This is the webpage containing quotes we want to scrape

# Create an empty list to store the results of the crawl (quotes and authors)
results = []

# Create a Scrapy process to manage the crawling
process = CrawlerProcess(settings={                 # Settings define the behavior of the Scrapy crawl
    'LOG_LEVEL': 'ERROR',                           # Set the logging level to 'ERROR' to avoid unnecessary log messages
    'FEEDS': {
        'outputs/scrapy_output_jupyter_subprocess_manypages.json': {     # Specify the location where the output will be saved
            'format': 'json',                       # Define the output format to be JSON
            'overwrite': True,                      # Overwrite if neccessary
        },
    },
})

# Define the spider class that will handle the crawling; it inherits from scrapy.Spider
class SimpleSpider(scrapy.Spider):
    name = 'simple'     # The name of the spider (can be used to refer to the spider)
    start_urls = [url]*100  # The list of URLs to begin the crawling process. Here it's 100 URLs

    # The parse method is where we define how to extract information from the webpage
    # The parse method is automatically called by Scrapy when it loads a page
    def parse(self, response):                  # The 'response' is the HTML content returned from the page
        for quote in response.css('div.quote'): # Loop through each 'quote' element on the page

            # Extract the quote text and author, and append them to the results list
            yield {  # Scrapy automatically handles returning items (instead of appending to a list)
                'text': quote.css('span.text::text').get(),     # Extract the quote text using CSS selectors
                'author': quote.css('small.author::text').get() # Extract the author using CSS selectors
            }

# Add the SimpleSpider to the Scrapy process and start the crawl
process.crawl(SimpleSpider) # Add the spider to the process to be run
process.start()             # Start the crawling process
