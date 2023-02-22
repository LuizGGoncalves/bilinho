require 'rails_helper'

RSpec.describe UseCase do
  describe ".perform" do
    class Dummy
      include UseCase

      def initialize(teste)
        @teste = teste
      end
    end
    context "when peform is implemented" do
      it "include UseCase, generate a new instance with arguments and perform it" do
        args = { teste: "laranja" }
        use_case = instance_double(Dummy, perform: true)
        allow(Dummy).to receive(:new).with(args).and_return(use_case)

        expect(Dummy.perform(args)).to be_truthy
        expect(Dummy).to have_received(:new).with(args)
        expect(use_case).to have_received(:perform)
      end
    end

    context "when perform is not implemented" do
      it 'raises a NotImplementedError' do
        use_case = Dummy.new({})
        expect { use_case.perform }.to raise_error(NotImplementedError)
      end
    end
  end
end
