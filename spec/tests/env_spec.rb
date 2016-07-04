require "serverspec"
require "docker"

set :backend, :docker

describe "Dockerfile" do
  before(:all) do
    @container = Docker::Container.create(
      'Image' => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      'Tty' => true,
      'Cmd' => 'bash'
    )
    @container.start
    set :docker_container, @container.id
  end

  describe file("/etc/debian_version") do
    its(:content) { should match "^8\."}
  end

  describe process("bash") do
    its(:user) { should eq "app" }
    its(:pid) { should eq 1 }
  end

  describe user('app') do
    it { should exist }
    it { should have_uid 1000 }
    it { should belong_to_primary_group 'app' }
    it { have_home_directory }
  end

  describe group('app') do
    it { should exist }
    it { should have_gid 1000 }
  end

  describe package('make') do
    it { should be_installed }
  end

  after(:all) do
    if !@container.nil?
      @container.delete('force' => true)
    end
  end
end
