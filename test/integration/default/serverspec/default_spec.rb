require 'serverspec'

## We'll assume a system-level install for testing purposes
describe file('/usr/local/rbenv') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/usr/local/rbenv/bin/rbenv') do
  it { should be_file }
  it { should be_executable }
  it { should be_executable.by('others') }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

# Test that default gems were installed
describe file('/usr/local/rbenv/shims/bundle') do
  it { should be_file }
  it { should be_executable }
  it { should be_executable.by('others') }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe command('bash -l -c "bundle --version"') do
  its(:stdout) { should match /^Bundler version .*/ }
  its(:exit_status) { should eq 0 }
end

describe command('bash -l -c "which rbenv"') do
  its(:stdout) { should match /\/usr\/local\/rbenv\/bin\/rbenv/ }
  its(:exit_status) { should eq 0 }
end

describe command('bash -l -c "rbenv --version"') do
  its(:stdout) { should match /^rbenv .*/ }
  its(:exit_status) { should eq 0 }
end
