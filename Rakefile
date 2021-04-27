require 'tempfile'

repo1 = "ghcr.io/digital-identity-labs/shibwright"
repo2 = "digitalidentity/shibwright"
snapshot_name = "shibwright:snapshot"
full_version = File.read("VERSION").to_s.strip

task :default => :refresh

task :refresh => [:build]

desc "Rebuild the image"
task :rebuild => [:force_reset, :build]

desc "Build and tag the images"
task :build do

  tmp_file = Tempfile.new("docker")
  git_hash = `git rev-parse --short HEAD`

  rebuild_or_not = ENV["SHIBWRIGHT_FORCE_REBUILD"] ? "--pull --force-rm" : ""

  sh [
       "docker build --iidfile #{tmp_file.path}",
       "--label 'version=#{full_version}'",
       "--label 'org.opencontainers.image.revision=#{git_hash}'",
       rebuild_or_not,
       "./"
     ].join(" ")

  image_id = File.read(tmp_file.path).to_s.strip

  sh "docker tag #{image_id} #{repo1}:#{full_version}"
  sh "docker tag #{image_id} #{repo1}:latest"
  sh "docker tag #{image_id} #{repo2}:#{full_version}"
  sh "docker tag #{image_id} #{repo2}:latest"
  sh "docker tag #{image_id} #{snapshot_name}"

end

task :shell => [:build] do
  sh "docker run -d #{snapshot_name}"
  container_id = `docker ps -q -l`.chomp
  sh "docker exec -it #{container_id} /bin/bash"
end

desc "Build and publish all Docker images to Github and Dockerhub"
task publish: ["build"] do

  sh "docker image push #{repo1}:#{full_version}"
  sh "docker image push #{repo1}:latest"
  sh "docker image push #{repo2}:#{full_version}"
  sh "docker image push #{repo2}:latest"

end

task :force_reset do
  ENV["SHIBWRIGHT_FORCE_REBUILD"] = "yes"
end
