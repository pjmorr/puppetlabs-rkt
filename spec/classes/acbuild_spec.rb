require 'spec_helper'

describe 'rkt::acbuild' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should contain_class('rkt::acbuild') }
      it { should contain_class('rkt::params') }
      it { should contain_package('curl') }
      it { should contain_archive('acbuild-v0.4.0').with_ensure('present') }

      ['acbuild', 'acbuild-script', 'acbuild-chroot'].each do |script|
        it do
          should contain_file("/usr/local/bin/#{script}")
            .with_target("/usr/local/src/acbuild-v0.4.0/#{script}")
            .with_ensure('link')
        end
      end

      context 'with a custom version' do
        let(:params) { { 'version' => '1.0.0' } }
        it { should contain_archive('acbuild-v1.0.0').with_url(/v1\.0\.0/) }
      end

      context 'with ensure absent' do
        let(:params) { { 'ensure' => 'absent' } }
        it { should contain_file('/usr/local/bin/acbuild').with_ensure('absent') }
        it { should contain_archive('acbuild-v0.4.0').with_ensure('absent') }
      end
    end
  end
end
