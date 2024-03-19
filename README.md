# rive_pull_to_refresh

<div align="center">
	<a href="https://flutter.io">
    	<img src="https://img.shields.io/badge/Platform-Flutter-blue"alt="Platform" />
	<a href="https://github.com/phucho236/RivePullToRefresh/blob/master/LICENSE">
    	<img src="https://img.shields.io/badge/MIT-LICENSE-orange"alt="LICENSE" />
	<a href="https://github.com/phucho236/RivePullToRefresh">
    	<img src="https://img.shields.io/badge/HomePage-RivePullToRefresh-blue"alt="HomePage" />
</div>
		
# Intro

- A custom refresh indicator with Rive, Image, GIF...
- Integrate rive quickly
- Provides callbacks for the pull-to-refresh action:
	+ value when the client pulls down, pulls up.
	+ stop scrolling
	+ close header
	...
- Customize
	+ floating, header mode
	+ percent resize to activate refresh
	+ Duration, Cuver
	+ ...
<div align="center">
	<table>
		<thead>
			<tr>
			<th style="text-align:center"><code>planet</code></th>
			<th style="text-align:center"><code>liquid</code></th>
			<th style="text-align:center"><code>bow</code></th>
			</tr>
		</thead>
		<tbody>
			<tr>
			<td style="text-align:center"><img src="https://github.com/phucho236/RivePullToRefresh/blob/master/assets/planet.gif?raw=true" height = "500px"/></td>
			<td style="text-align:center"><img src="https://github.com/phucho236/RivePullToRefresh/blob/master/assets/liquid.gif?raw=true" height = "500px"/></td>
			<td style="text-align:center"><img src="https://github.com/phucho236/RivePullToRefresh/blob/master/assets/bow.gif?raw=true" height = "500px"/></td>
			</tr>
		</tbody>
	</table>
</div>
<div align="center">
	<table>
		<thead>
			<tr>
			<th style="text-align:center"><code>space</code></th>
			<th style="text-align:center"><code>lipid</code></th>
			<th style="text-align:center"> </th>
			</tr>
		</thead>
		<tbody>
			<tr>
			<td style="text-align:center"><img src="https://github.com/phucho236/RivePullToRefresh/blob/master/assets/space.gif?raw=true" height = "500px"/></td>
			<td style="text-align:center"><img src="https://github.com/phucho236/RivePullToRefresh/blob/master/assets/lipid.gif?raw=true" height = "500px"/></td>
			</tr>
		</tbody>
	</table>
</div>

# Wanrning
- You must know a little bit of rive. If not you can use the existing rive files in the example(can't edit color from the Flutter side).

# Flutter Side

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:
```yaml
rive_pull_to_refresh: ^1.0.1
```

### 2. Install it
You can install packages from the command line:\
with `dart`:

```css
dart pub get
```

with `Flutter`:

```css
flutter pub get
```

### 3. Import it
```dart
import 'package:rive_pull_to_refresh/rive_pull_to_refresh.dart';
```

# Rive Side
Check editor Rive to know State Machine and Inputs [here](https://rive.app/community/8964-17117-pull-to-refresh)
# Example use rive file from:

[JcToon](https://rive.app/@JcToon/) : [community](https://rive.app/community/3146-6725-pull-to-refresh/)\
[Drawsgood](https://rive.app/@drawsgood/) : [community](https://rive.app/community/5251-10495-pull-to-refresh-use-case/)\
[RiveExamples](https://rive.app/@RiveExamples/) : [community](https://rive.app/community/516-982-interactive-animations/)\
Thank all.

# Support the package(optional)
<div  align="left">
	<h6>If you find this package useful.<br>You can support it by giving it a thumbs up or buy me a coffee.<br>Thank you !</\h6><br>
  	<a href="https://www.paypal.com/paypalme/phucho2306">
    	<img src="https://img.shields.io/badge/Donate-Paypal-blue"alt="Donate" />
	<a href="https://me.momo.vn/G9IguZfofzt3CdtWuMu7">
    	<img src="https://img.shields.io/badge/Donate-Momo-D82d88"alt="Donate" />
</div>

