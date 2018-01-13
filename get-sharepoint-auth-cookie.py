#!/usr/bin/python

from __future__ import print_function

try:
    from http.cookiejar import CookieJar
except ImportError:
    from cookielib import CookieJar

try:
    from urllib.error import URLError
except ImportError:
    from urllib2 import URLError

try:
    from urllib.parse import urlparse
except ImportError:
    from urlparse import urlparse

try:
    from urllib.request import urlopen, build_opener, HTTPCookieProcessor, Request
except ImportError:
    from urllib2 import urlopen, build_opener, HTTPCookieProcessor, Request

import sys
import xml.etree.ElementTree as ET


authXml = """<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope"
      xmlns:a="http://www.w3.org/2005/08/addressing"
      xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
  <s:Header>
    <a:Action s:mustUnderstand="1">http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action>
    <a:ReplyTo>
      <a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
    </a:ReplyTo>
    <a:To s:mustUnderstand="1">https://login.microsoftonline.com/extSTS.srf</a:To>
    <o:Security s:mustUnderstand="1"
       xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
      <o:UsernameToken>
        <o:Username>{0}</o:Username>
        <o:Password>{1}</o:Password>
      </o:UsernameToken>
    </o:Security>
  </s:Header>
  <s:Body>
    <t:RequestSecurityToken xmlns:t="http://schemas.xmlsoap.org/ws/2005/02/trust">
      <wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy">
        <a:EndpointReference>
          <a:Address>{2}</a:Address>
        </a:EndpointReference>
      </wsp:AppliesTo>
      <t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType>
      <t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType>
      <t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType>
    </t:RequestSecurityToken>
  </s:Body>
</s:Envelope>
"""


def main():
    if len(sys.argv) < 3:
        print("Usage: get-sharepoint-auth-cookie.py endpointURL username password", file=sys.stderr)
        exit(1)

    endpoint = sys.argv[1]
    username = sys.argv[2]
    password = sys.argv[3]

    authReq = authXml.format(username, password, endpoint)
    try:
        request = urlopen("https://login.microsoftonline.com/extSTS.srf", authReq.encode('utf-8'))
    except URLError:
        print("Failed to send login request.", file=sys.stderr)
        exit(1)

    ns = {"soap": "http://www.w3.org/2003/05/soap-envelope",
          "wssec": "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"}

    authRespTree = ET.parse(request)
    authToken = None
    fault = authRespTree.find(".//soap:Fault", ns)
    if fault is not None:
        reason = fault.find("soap:Reason/soap:Text", ns)
        if reason is not None:
            reason = reason.text
        else:
            reason = "*Unknown reason*"
        print("Railed to retrieve authentication token: {}".format(reason))
        exit(1)

    tokenElm = authRespTree.find(".//wssec:BinarySecurityToken", ns)
    if tokenElm is None:
        print("Failed to retrieve authentication token.", file=sys.stderr)
        exit(1)
    else:
        authToken = tokenElm.text

    endpointUrl = urlparse(endpoint)
    if endpointUrl.scheme not in ["http", "https"] or not endpointUrl.netloc:
        print("Invalid endpoint URL: {}".format(endpoint), file=sys.stderr)
        exit(1)

    cookiejar = CookieJar()
    opener = build_opener(HTTPCookieProcessor(cookiejar))
    try:
        request = Request("{0}://{1}/_forms/default.aspx?wa=wsignin1.0".format(
            endpointUrl.scheme, endpointUrl.netloc))
        response = opener.open(request, data=authToken.encode('utf-8'))
        cookieStr = ""
        cookiesFound = []
        for cookie in cookiejar:
            if cookie.name in ("FedAuth", "rtFa"):
                cookieStr += cookie.name + "=" + cookie.value + "; "
                cookiesFound.append(cookie.name)

        if "FedAuth" not in cookiesFound or "rtFa" not in cookiesFound:
            print("Incomplete cookies retrieved.", file=sys.stderr)
            exit(1)
        print(cookieStr)
    except URLError as x:
        print("Failed to login to SharePoint site: {}".format(x.reason))
        exit(1)

if __name__ == '__main__':
    main()
