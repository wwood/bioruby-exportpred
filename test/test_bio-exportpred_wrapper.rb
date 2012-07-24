require 'helper'

# This class is for testing when the actual exportpred program is present in the user's PATH, and is run
class TestBioExportpred < Test::Unit::TestCase
  def test_wrapper_positive
    positive = 'MAVSTYNNTRRNGLRYVLKRRTILSVFAVICMLSLNLSIFENNNNNYGFHCNKRHFKSLAEASPEEHNNLRSHSTSDPKKNEEKSLSDEINKCDMKKYTAEEINEMINSSNEFINRNDMNIIFSYVHESEREKFKKVEENIFKFIQSIVETY'
    result = Bio::ExportPred::Wrapper.new.calculate(positive)
    assert_equal true, result.signal?
    assert result.predicted_rle?
  end
  
  def test_wrapper_negative
    negative = 'MKILLLCIIFLYYVNAFKNTQKDGVSLQILKKKRSNQVNFLNRKNDYNLIKNKNPSSSLKSTFDDIKKIISKQLSVEEDKIQMNSNFTKDLGADSLDLVELIMALEEKFNVTISDQDALKINTVQDAIDYIEKNNKQ'
    assert_equal false, Bio::ExportPred::Wrapper.new.calculate(negative).signal?
  end
  
  def test_no_rle
    positive = 'MAVSTYNNTRRNGLRYVLKRRTILSVFAVICMLSLNLSIFENNNNNYGFHCNKRHFKSLAEASPEEHNNLRSHSTSDPKKNEEKSLSDEINKCDMKKYTAEEINEMINSSNEFINRNDMNIIFSYVHESEREKFKKVEENIFKFIQSIVETY'
    result = Bio::ExportPred::Wrapper.new.calculate(positive, :no_RLE => true)
    assert_equal nil, result.predicted_rle?
    assert_equal false, result.signal?
  end
end
