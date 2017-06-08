RSpec.describe Licensee::Matchers::Cran do
  let(:mit) { Licensee::License.find('mit') }
  let(:gpl2) { Licensee::License.find('gpl-2.0') }
  let(:gpl3) { Licensee::License.find('gpl-3.0') }
  let(:content) { "License: MIT + file LICENSE\nPackage: test" }
  let(:file) { Licensee::Project::LicenseFile.new(content, 'DESCRIPTION') }
  subject { described_class.new(file) }

  it 'stores the file' do
    expect(subject.file).to eql(file)
  end

  it 'matches MIT' do
    expect(subject.match).to eql(mit)
  end

  it 'is confident' do
    expect(subject.confidence).to eql(90)
  end

  {
    'MIT'                      => Licensee::License.find('mit'),
    'MIT + file LICENSE'       => Licensee::License.find('mit'),
    'GPL (>=2)'                => Licensee::License.find('gpl-2.0'),
    'GPL( >= 2 )'              => Licensee::License.find('gpl-2.0'),
    'GPL (>=2) + file LICENSE' => Licensee::License.find('gpl-2.0'),
    'GPL (>=3)'                => Licensee::License.find('gpl-3.0'),
    'GPL-2'                    => Licensee::License.find('gpl-2.0'),
    'GPL-3'                    => Licensee::License.find('gpl-3.0')
  }.each do |license_declaration, license|
    context "with '#{license_declaration}' declaration" do
      let(:content) { "Package: test\nLicense: #{license_declaration}" }

      it 'matches' do
        expect(subject.match).to eql(license)
      end
    end
  end
end
