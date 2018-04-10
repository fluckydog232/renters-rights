class Zillow
  include HTTParty
  format :xml
  base_uri 'http://www.zillow.com/webservice'

  attr_accessor :zws_id, :http_timeout, :yearBuilt, :useCode, :city, :type

  def initialize(zws_id, http_timeout = nil)
    self.zws_id = zws_id
    self.http_timeout = http_timeout
    self.class.default_params "zws-id" => zws_id
    self.yearBuilt = yearBuilt
    self.useCode = useCode
    self.city = city
    self.type = type
  end

  # Find yearBuilt
  # Determine if built before September 7, 1979
  # Find useCode
  # Determine total units - if 2, 3+ or 4+
  # Find city
  # Determine if San Jose
  # Find type
  # Determine if region type=city || type =neighborhood

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
    else
      # raises the net/http response that was raised
      raise response.response
    end
  end

end

# addressCheck(key,address,citystatezip) {
#
#   key=$kws_id;
#   url="http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=${kws_id}&address=#{street}&citystatezip=#{citystatezip}";
#
# }
