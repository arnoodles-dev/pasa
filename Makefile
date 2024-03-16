GENHTML=C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml
LCOV=C:\ProgramData\chocolatey\lib\lcov\tools\bin\lcov

## Setup Commands ----------------------------------------

## Note: In windows, recommended terminal is cmd 

ensure_flutter_version: ## Ensures flutter version is 3.19.3 
	fvm install 3.19.3
	fvm use 3.19.3
	fvm global 3.19.3

## Note: If you are using a specific flutter version, change '3.19.3' to the desired '{flutter version}' you want to use

clean: ## Delete the build/ and .dart_tool/ directories
	fvm flutter clean
	
pub_clean: ## Empties the entire system cache to reclaim extra disk space or remove problematic packages
	fvm flutter pub cache clean	

pub_get: ## Gets pubs
	fvm flutter pub get
	cd plugins/google_mobile_service && fvm flutter pub get
	cd plugins/mobile_service_core && fvm flutter pub get
	cd ../..

pub_outdated: ## Check for outdated packages
	fvm flutter pub outdated
	cd plugins/google_mobile_service && fvm flutter pub outdated
	cd plugins/mobile_service_core && fvm flutter pub outdated

pub_repair: ## Performs a clean reinstallation of all packages in your system cache
	fvm flutter pub cache repair

l10n: ## Generates strings
	fvm dart plugins/i18n_generator/lib/main.dart --output lib/app/generated/app_localization_lookup.generated.dart

build_runner: ## This command generates the files for the code generated dependencies
	fvm dart run build_runner build --delete-conflicting-outputs

build_runner_watch: ## This command generates the files for the code generated dependencies 'automatically during development' 
	fvm dart run build_runner watch --delete-conflicting-outputs

format: ## This command formats the codebase and run import sorter
	fvm dart format lib/ test/ plugins/google_mobile_service/lib/ plugins/mobile_service_core/lib/ plugins/i18n_generator/lib/

clean_rebuild: ensure_flutter_version clean pub_clean pub_get l10n build_runner format lint fix_lint

rebuild: ensure_flutter_version pub_get l10n build_runner format lint fix_lint

lint: ## Analyzes the codebase for issues
	fvm flutter analyze lib test
	fvm dart analyze lib test

fix_lint: ## Fixes lint issues
	fvm dart fix --apply

icons_launcher: ## This command runs icons_launcher
	fvm dart run icons_launcher:create

native_splash: ## This command runs flutter_native_splash
	fvm dart run flutter_native_splash:create

dependency_validator: ## This command runs dependency_validator
	fvm dart run dependency_validator		

lcov_gen: ## Generates lcov
	fvm flutter test --coverage

lcov_gen_ci: ## Generates lcov in CI environment
	fvm flutter test --dart-define=CI=true --coverage

lcov_gen_unit: ## Generates lcov for unit tests only
	fvm flutter test test/unit --coverage 

lcov_gen_widget: ## Generates lcov for widget tests only
	fvm flutter test test/widget --coverage 

lcov_report_mac: ## Generates lcov report for macOS
	lcov --ignore-errors unused --remove  coverage/lcov.info  'lib/app/*' 'lib/bootstrap.dart' '*.g.dart'  '*.freezed.dart' '*.dto.dart' '*.config.dart' '*.chopper.dart' '*_webview.dart' '**/service/*' '**/entity/*' '**/dto/*' -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/
	open coverage/index.html		

lcov_report_win:  ## Generates lcov report for Windows
	perl ${LCOV} lcov --ignore-errors unused --remove  coverage/lcov.info  'lib/app/*' 'lib/bootstrap.dart' '*.g.dart'  '*.freezed.dart' '*.dto.dart' '*.config.dart' '*.chopper.dart' '*_webview.dart' '**/service/*' '**/dto/*' '**/entity/*' -o coverage/lcov.info
	perl ${GENHTML} -o coverage/html coverage/lcov.info
	CMD /C start coverage/html/index.html	

lcov_win: lcov_gen lcov_report_win ## Generates the lcov report and automatically opens the coverage report for Windows

lcov_mac: lcov_gen lcov_report_mac  ## Generates the lcov report and automatically opens the coverage report for macOS

update_goldens: ## Updates the golden files
	fvm flutter test --update-goldens

delete_goldens_win: ## Delete the all golden files in Windows
	CMD /C FOR /d /r "test/widget" %d IN ("goldens") DO @IF EXIST "%d" rd /s /q "%d"

delete_failures_win: ## Delete the all failed golden files in Windows
	CMD /C FOR /d /r "test/widget" %d IN ("failures") DO @IF EXIST "%d" rd /s /q "%d"

delete_failures_mac:  ## Delete the all golden files in macOS
	find ./test/widget -type d -name "failures" -exec rm -rf {} \;

delete_goldens_mac:  ## Delete the all failed golden files in macOS
	find ./test/widget -type d -name "goldens" -exec rm -rf {} \;

goldens_win: delete_goldens_win delete_failures_win update_goldens ## Deletes the existing goldens and failures and update the golden files for Windows

goldens_mac: delete_goldens_mac delete_failures_mac update_goldens ## Deletes the existing goldens and failures and update the golden files for macOS

build_android_dev:
	sh scripts/build_android.sh "apk" "release" "development" "lib/main_development.dart" "development.apk"