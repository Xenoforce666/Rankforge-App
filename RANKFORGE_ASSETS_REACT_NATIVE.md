# RankForge Assets and React Native Equivalents

This document lists the assets currently used by the RankForge Flutter app and maps them to their React Native equivalents.

## Current Flutter Assets

| Asset | Type | Used by | Source |
|---|---|---|---|
| `launch_background.xml` | Android drawable | Android launch/splash background | `android/app/src/main/res/drawable/launch_background.xml` |
| `launch_background` / `#101116` | Android color resource | Splash background color | `android/app/src/main/res/values/colors.xml` |
| `MaterialIcons-Regular.otf` | Flutter generated font asset | Material icons used across the UI | Enabled by `uses-material-design: true` in `pubspec.yaml` |
| Material `Icons.*` glyphs | Icon font glyphs | Navigation, cards, buttons, badges, settings, and exam cards | Used across `lib/screens` and `lib/widgets` |

No declared Flutter image assets such as PNG, JPG, SVG, WebP, GIF, or custom fonts were found in the active `prepquest` project.

## Material Icons Used

The app currently uses these Material icon concepts:

```txt
home
workspace_premium
checklist
bar_chart
insights
settings
today
track_changes
percent
task_alt
calendar_view_week
edit_calendar
schedule
save
account_balance
terrain
currency_rupee
check_circle
badge
dark_mode
delete_forever
info
person
restart_alt
stacked_bar_chart
local_fire_department
bolt
```

## React Native Equivalents

| Flutter / Android asset | React Native equivalent |
|---|---|
| `launch_background.xml` splash drawable | Android native splash screen background, usually `android/app/src/main/res/drawable/launch_screen.xml`, or configured through a library such as `react-native-bootsplash` |
| `launch_background` color `#101116` | Android resource color in `android/app/src/main/res/values/colors.xml`, or splash config color |
| Flutter `MaterialIcons-Regular.otf` | Icon font from `react-native-vector-icons/MaterialIcons` or `@expo/vector-icons/MaterialIcons` |
| Flutter `Icons.*` calls | React Native icon components such as `<MaterialIcons name="home" size={24} color="#..." />` |
| Flutter `uses-material-design: true` | Install and link/configure an icon package; React Native does not bundle Material Icons automatically |
| Flutter theme colors in Dart | JS/TS theme constants, for example `colors.ts`, or theme tokens from a styling library |
| App label `RankForge` in `AndroidManifest.xml` | Android `app_name` in `android/app/src/main/res/values/strings.xml`, plus iOS display name in `Info.plist` |

## Example React Native Icon Usage

```tsx
import MaterialIcons from 'react-native-vector-icons/MaterialIcons';

<MaterialIcons name="home" size={24} color="#F7F4ED" />
<MaterialIcons name="workspace-premium" size={24} color="#D7B46A" />
<MaterialIcons name="checklist" size={24} color="#39B68D" />
```

## Expected React Native Asset Structure

For the current RankForge design, a React Native app would mainly need:

```txt
android/app/src/main/res/drawable/launch_screen.xml
android/app/src/main/res/values/colors.xml
android/app/src/main/res/values/strings.xml
react-native-vector-icons Material Icons font
theme color constants in JS/TS
```

In short: the current Flutter app translates to native splash resources, a Material icon font, and theme colors in React Native. It does not require image files unless custom logos, illustrations, or other visual assets are added later.
