require 'HTTParty'

class Zillow
  include HTTParty
  format :xml
  base_uri 'http://www.zillow.com/webservice'

  attr_accessor :zws_id, :http_timeout, :yearBuilt, :useCode, :city, :type

  # https://www.zillow.com/howto/api/GetDeepSearchResults.htm has the full specifications of the API used

  def initialize(zws_id, http_timeout = nil)
    self.zws_id = zws_id
    self.http_timeout = http_timeout
    self.class.default_params "zws-id" => zws_id
    self.yearBuilt = yearBuilt
    self.useCode = useCode
    self.city = city
    self.type = type
  end

    # Find yearBuilt. Determine if built before September 7, 1979
    # Find useCode. Specifies type of property. Use useCode to determine total units - if 2, 3+ or 4+.
    # Find city. Determine if it is "SAN JOSE"
    # Find type. Determine if the type is neighborhood within San José; if it returns a city and the city="SAN JOSE",
    # then it is actually in unincorporated County region
    # def getInfo(key,address,citystatezip)
    #   url="http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=#{key}&address=#{address}&citystatezip=#{citystatezip}"
    #   page=HTTParty.get(url)
    #   if (page.parsed_response["searchresults"]["message"]["code"] == "0")
    #     useCode=page.parsed_response["searchresults"]["response"]["results"]["result"]["useCode"]
    #     yearBuilt=page.parsed_response["searchresults"]["response"]["results"]["result"]["yearBuilt"]
    #     bedrooms=page.parsed_response["searchresults"]["response"]["results"]["result"]["bedrooms"]
    #     return [useCode,yearBuilt,bedrooms]
    #   else
    #     # Handle error here
    #   end
    # end
    # getInfo(key,address,citystatezip);

  def query(address, citystatezip)
    options = { query: { address: address, citystatezip: citystatezip } }
    response = self.class.get("/GetDeepSearchResults.htm", options)
    if response.success?
      self.new(
        response["searchresults"]["response"]["results"]["result"]["address"]["city"],
        response["searchresults"]["response"]["results"]["result"]["useCode"],
        response["searchresults"]["response"]["results"]["result"]["yearBuit"],
        response["searchresults"]["response"]["results"]["result"]["localRealEstate"]["region type"]
      )
    end
  end

end

# addressCheck(key,address,citystatezip) {
#
#   key=$kws_id;
#   url="http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=${kws_id}&address=#{street}&citystatezip=#{citystatezip}";
#
# }
