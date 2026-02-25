// lib/core/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  // GNews API
  static const String gnewsBase = 'https://gnews.io/api/v4';
  static const String gnewsSearch = '$gnewsBase/search';

  // NewsData.io
  static const String newsDataBase = 'https://newsdata.io/api/1';
  static const String newsDataLatest = '$newsDataBase/news';

  // TheNewsAPI
  static const String theNewsApiBase = 'https://api.thenewsapi.com/v1';
  static const String theNewsApiTop = '$theNewsApiBase/news/top';

  // RSS Feeds (no key required)
  static const String etMarketsRss =
      'https://economictimes.indiatimes.com/markets/rss.cms';
  static const String moneyControlRss =
      'https://www.moneycontrol.com/rss/buzzingstocks.xml';
  static const String livemintRss = 'https://www.livemint.com/rss/markets';
  static const String businessStandardRss =
      'https://www.business-standard.com/rss/markets-106.rss';

  static const List<String> rssFeeds = [
    etMarketsRss,
    moneyControlRss,
    livemintRss,
    businessStandardRss,
  ];

  // Yahoo Finance (unofficial, no key)
  static const String yahooFinanceBase =
      'https://query1.finance.yahoo.com/v8/finance/chart';

  // Alpha Vantage
  static const String alphaVantageBase = 'https://www.alphavantage.co/query';

  // Finnhub
  static const String finnhubBase = 'https://finnhub.io/api/v1';
  static const String finnhubQuote = '$finnhubBase/quote';

  // NSE India (public, no key)
  static const String nseBase = 'https://www.nseindia.com/api';
  static const String nseNifty50 =
      '$nseBase/equity-stockIndices?index=NIFTY%2050';
  static const String nseBankNifty =
      '$nseBase/equity-stockIndices?index=NIFTY%20BANK';
  static const String nseMarketStatus = '$nseBase/market-status';
  static const String nseTopGainers =
      '$nseBase/live-analysis-variations?index=gainers';
  static const String nseTopLosers =
      '$nseBase/live-analysis-variations?index=loosers';

  // ExchangeRate (no key)
  static const String exchangeRateBase =
      'https://open.exchangerate-api.com/v6/latest/USD';

  // World Bank
  static const String worldBankCpi =
      'https://api.worldbank.org/v2/country/IN/indicator/FP.CPI.TOTL.ZG?format=json';
}
