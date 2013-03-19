require 'r2/translations_builder'

describe R2::TranslationsBuilder do

  describe ".compile" do

    context "with no block given" do
      subject {
        R2::TranslationsBuilder.compile
      }

      it { should be_nil }
    end

    context "with a block with two translation directives" do
      subject {
        R2::TranslationsBuilder.compile do
          match :property => /foo/ do
            value.gsub!('bar', 'pub')
          end
          match :value => /hoo/ do
            value.gsub!('hoo', 'haa')
          end
        end
      }

      it { should be_an_instance_of(Array) }
      its(:size)  { should eq(2) }
      its(:first) { should be_an_instance_of(R2::Translation) }
      its(:last)  { should be_an_instance_of(R2::Translation) }
    end

  end
end
