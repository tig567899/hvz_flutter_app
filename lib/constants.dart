
class Constants {
  static const PRODUCTION_URL = 'https://uwhvz.uwaterloo.ca/api/v1/';
  // Change this to your testing server
  static const TESTING_URL = 'http://tigerkong.me:7126/api/v1/';

  // Twitter
  static const TWITTER_API_KEY = "Y1KzPRQizRyKge8xkfuYrrBfc";
  static const TWITTER_API_SECRET_KEY = "FNhhLCQVEfeiHrOlTk9E52luNiGtoghnCdYVJkG0Gc6DNEQYe2";
  static const TWITTER_API_TOKEN = "751400215308017664-1yFISFLqv8kBMMNtlVfvTNdnZrFRm36";
  static const TWITTER_API_TOKEN_SECRET = "2pAJvJ1kC7yTbid9ss7y0vydjZ8myRisktvZwV3tIKmAn";
}

enum DrawerState {
  PROFILE,  // 0
  TAG_STUN, // 1
  TWITTER,  // 2
  ERROR,    // 3
}