# coding: utf-8

import scrapy
import urlparse

class PragueSpider(scrapy.Spider):
    name = "prague"

    start_urls = [ 'http://www.praha.eu/jnp/cz/o_meste/primator_a_volene_organy/zastupitelstvo/vysledky_hlasovani/index.html' ]

    period_url = "http://www.praha.eu/jnp/cz/o_meste/primator_a_volene_organy/zastupitelstvo/vysledky_hlasovani/index.html?size=50&periodId=%d&resolutionNumber=&printNumber=&s=1&meeting=&start=%d"


    current_period = 29783
    period_page_size = 50

    def period_request(self, period_id, offset):
        rq = scrapy.Request(self.period_url % (period_id, offset),
                            callback = self.parse_period)
        rq.meta['offset'] = offset
        rq.meta['period'] = period_id
        #self.logq( "REQ %d %d" %( period_id, offset))
        return rq

    def gft(self, es):
        if (len(es) > 0):
            es[0].extract()
        else:
            return ""

    def parse(self, response):
        clubs = response.xpath(u"//a[text()='Politické kluby']/@href").extract_first()
        yield scrapy.Request(response.urljoin(clubs), callback=self.parse_clubs)
        for period in response.css("select#periodId > option"):
            id = period.css("::attr(value)").extract_first()
            name = period.css("::text").extract_first()
            if (name is None):
                continue
            #self.log('Period %s, id: %s' % (name, id))
            id = int(id)
            yield {
                'type': 'period',
                'id': id,
                'name': name,
            }

            if id != self.current_period:
                continue
            yield self.period_request(id,0)

    def  parse_clubs(self, response):
        for row in response.css(".data-grid.wide > tbody > tr"):
            name = row.css("td > a::text").extract_first()
            url = row.css("td > a::attr(href)").extract_first()
            url = response.urljoin(url)
            rq = scrapy.Request(url, callback=self.parse_club)
            rq.meta["club"] = name
            yield rq

    def parse_club(self, response):
        club = response.meta["club"]
        for row in response.css(".data-grid.wide > tbody > tr"):
            name = row.css("td > a::text").extract_first()
            position = row.xpath("td[2]/text()").extract_first()
            yield {
                'type': 'club-member',
                'club': club,
                'name': name,
                'position': position,
            }


    def parse_period(self, response):
        some = False
        for row in response.css(".data-grid.wide > tbody > tr"):
            resolve_id = row.xpath("td[1]/text()").extract_first()
            date = row.xpath("td[2]/text()").extract_first()
            document = row.xpath("td[3]/text()").extract_first()
            name = row.xpath("td[4]/text()").extract_first()
            result = row.css("td > a")
            result_text = result.css("::text").extract_first()
            result_url = response.urljoin(result.css("::attr(href)").extract_first());
            purl = urlparse.urlparse(result_url)
            vote_id = int(urlparse.parse_qs (purl.query)['votingId'][0])
            yield {
                'type': 'vote',
                'resolve_id': resolve_id,
                'date': date,
                'document': document,
                'name': name,
                'result_text': result_text,
                'result_url': result_url,
                'vote_id': vote_id
            }
            #self.log("VOTE: %s %s %s %s %s" % (vote_id, date, document, name, result))
            rq = scrapy.Request(result_url, callback=self.parse_vote)
            rq.meta['vote_id'] = vote_id
            yield rq
            some = True
        if some:
            yield self.period_request(response.meta['period'],
                                      response.meta['offset']+self.period_page_size)

    def parse_vote(self, response):
        vote_id = response.meta['vote_id']
        for row in response.css(".data-grid.wide > tbody > tr"):
            cells = row.css("td")
            name = cells[0].css("a::text").extract_first().strip('\n\r')
            result = cells[1].css("::text").extract_first().strip('\n\r')
            yield {
                'type': 'vote-detail',
                'name': name,
                'vote_id': vote_id,
                'result': result
            }
