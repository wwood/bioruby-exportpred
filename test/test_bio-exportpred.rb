require 'helper'

class TestBioExportpred < Test::Unit::TestCase
  def test_create_from_line
    # test empty
    line = ''
    r = Bio::ExportPred::Result.create_from_line(line)
    assert r
    assert_kind_of Bio::ExportPred::Result, r
    assert_equal false, r.predicted?
    
    line = 'metoo	RLE	6.44141	[a-met:M][a-leader:AVSTYNNTRRNGLRYVLKRR][a-hydrophobic:TILSVFAVICMLSL][a-spacer:NLSIFENNNNNYGFHCNKRH][a-RLE:FKSLAEA][a-tail:SPEEHNNLRSHSTSDPKKNEEKSLSDEINKCDMKKYTAEEINEMINSSNEFINRNDMNIIFSYVHESEREKFKKVEENIFKFIQSIVETYKIPDEYKMRKFKFAHFEMQGYALKQEKFLLEYAFLSLNGKLCERKKFKEVLEYVKREWIEFRKSMFDVWKEKLASEFREHGEMLNQKRKLKQHELDRRAQREKMLEEHSRGIFAKGYLGEVESETIKKKTEHHENVNEDNVEKPKLQQHKVQPPKVQQQKVQPPKSQQQKVQPPKSQQQKVQPPKVQQQKVQPPKVQKPKLQNQKGQKQVSPKAKGNNQAKPTKGNKLKKN]'
    r = Bio::ExportPred::Result.create_from_line(line)
    assert r
    assert_kind_of Bio::ExportPred::Result, r
    assert r.predicted?
    assert_equal 6.44141, r.score
  end
  
  def test_create_from_line_options
    # test empty
    line = ''
    r = Bio::ExportPred::Result.create_from_line(line, :no_RLE => true)
    assert r
    assert_kind_of Bio::ExportPred::Result, r
    assert_equal false, r.predicted_kld
    assert_equal nil, r.predicted_rle
  end
  
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
