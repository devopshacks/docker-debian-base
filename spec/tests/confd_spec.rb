require "serverspec"
require "docker"

set :backend, :docker

describe "Dockerfile" do
  before(:all) do
    @container = Docker::Container.create(
      :Image => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      :Tty => true,
      :Cmd => 'bash',
      :Env => [
        'USER=root',
        'CONFD_PREFIX=/test',
        'TEST_SAMPLE_VALUE=foo'
      ],
      :HostConfig => {
        :Binds => [
          Dir.pwd + '/spec/rsc/confd:/etc/confd:ro'
        ]
      }
    )
    @container.start
    set :docker_container, @container.id
  end

  describe command('confd --version') do
    its(:stdout) { should eq "confd 0.11.0\n" }
  end

  describe file('/tmp/confd-test') do
    its(:content) { should eq "foo\n" }
  end

  after(:all) do
    if !@container.nil?
      @container.delete(:force => true)
    end
  end
end
