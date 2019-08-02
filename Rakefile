@success = true

allure_version = '2.12.1'
allure_cli_dir = "./build/allure-2.12.1"

def run_tests(browser, docker_image, out_dir)
  sh(%{docker_image="#{docker_image}" browser="#{browser}"
              bundle exec parallel_cucumber features --group-by scenarios
                -n 20
                -o "
                    --format Allure::CucumberFormatter --out #{out_dir}
                    --format pretty
                    "
              }.gsub(/\s+/, " ").strip) do |success, _exit_code|
    @success &= success
  end
end

task :test => [:test_multiple]

task :report do
  if !File.directory?(allure_cli_dir)
    puts "Downloading Allure #{allure_version}..."
    sh(%{
      curl http://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/#{allure_version}/allure-commandline-#{allure_version}.zip -o build/allure-commandline.zip
      unzip build/allure-commandline.zip -d build
    })
  end
  puts "Generating report..."
  sh(%{
     #{allure_cli_dir}/bin/allure generate -c -o build/allure-report build/allure-results
  })
end

task :firefox do
  run_tests('firefox', 'selenium/standalone-firefox:3', 'build/allure-results')
end

task :chrome do
  run_tests('chrome', 'selenium/standalone-chrome:3', 'build/allure-results')
end

multitask :test_multiple => [:firefox, :chrome] do
  puts 'Running automation for'
  raise StandardError, "Tests failed!" unless @success
end