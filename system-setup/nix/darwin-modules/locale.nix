# Region and formats. Apps read these at launch and the language list is cached for
# the login session, so changes need a logout to show up.
{ ... }:

{
  system.defaults.CustomUserPreferences.NSGlobalDomain = {
    AppleLanguages = [
      "en-GB"
      "ar-GB"
    ];
    AppleLocale = "en_GB"; # General > Language & Region > Region

    # en_GB implies a 24-hour clock; override it back to am/pm.
    AppleICUForce12HourTime = true; # General > Date & Time > 24-hour time: off
  };
}
