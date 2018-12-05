import os
import sys
from mitmproxy import http
from mitmproxy.master import Master
from mitmproxy.proxy import ProxyConfig, ProxyServer
from mitmproxy.options import Options
from mitmproxy.addons import core
import time
import pandas as pd
import csv

flow_df = pd.DataFrame()

class Counter:

    def request(self, flow):

        # write the collecting network flow into a csv file
        with open("url_logs.csv","a+") as csvfile:
            writer = csv.writer(csvfile)
            # get he HTTP referer header
            header_fields = flow.request.headers.fields
            referer_header = [head[1].decode('utf-8') for head in header_fields if head[0].lower() == b'referer']
            referer_header_str = ""
            for h in referer_header:
                referer_header_str = referer_header_str + h
            # write all the needed data line by line
            writer.writerow([flow, referer_header_str, flow.request, flow.server_conn, flow.client_conn, flow.request.host, time.time() * 1000])

class TestInterceptor(Master):
    def __init__(self, options, server):
        Master.__init__(self, options)
        self.server = server

    def run(self):
        while True:
            try:
                Master.run(self)
            except KeyboardInterrupt:
                self.shutdown()
                sys.exit(0)

def start_proxy(port):
    options = Options(
        listen_port=port,
    )
    config = ProxyConfig(
        options=options,
    )
    server = ProxyServer(config)
    print('Intercepting Proxy listening on {0}'.format(port))
    m = TestInterceptor(options, server)
    m.addons.add(core.Core())
    m.addons.add(Counter())
    m.run()

if __name__ == '__main__':
    start_proxy(8080)