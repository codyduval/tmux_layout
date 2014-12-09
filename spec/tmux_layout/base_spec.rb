require "spec_helper"

module TmuxLayout
  describe CheckSum do
    it "should take and hold a string" do
      csum = CheckSum.new('HELLO')

      expect(csum.config_string).to eq('HELLO')
    end

    it "should return a checksum" do
      checksum = CheckSum.new('159x48,0,0{79x48,0,0,79x48,80,0}')
      csum_value = checksum.csum
      
      expect(csum_value).to eq('bb62')
    end

  end
end
