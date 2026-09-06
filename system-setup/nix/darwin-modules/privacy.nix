# Siri and Apple's ad personalisation, both off.
{ ... }:

{
  system.defaults.CustomUserPreferences = {
    "com.apple.assistant.support"."Assistant Enabled" = false; # disable Siri

    "com.apple.Siri" = {
      StatusMenuVisible = false;
      VoiceTriggerUserEnabled = false; # no "Hey Siri"
    };

    "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
  };
}
