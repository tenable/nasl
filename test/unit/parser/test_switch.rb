################################################################################
# Copyright (c) 2011-2018, Tenable Network Security
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

class TestSwitch < Test::Unit::TestCase
  include Nasl::Test

  def test_each
    tree = parse(
      <<-EOF
switch (value)
{
  case 0:
    b = 1;
    break;
  case 3:
    break;
  default:
    a = 0;
}
switch [=~] (value1)
{
  case "^abc.*":
    rtrn = 1;
    break;
  case "^cde.*":
    rtrn = 2;
    break;
  default:
    rtrn = 1;
}
switch (value2)
{
  case [=~] "^abc.*":
    rtrn = 1;
    break;
  case [==] "cde":
    rtrn = 2;
    break;
  default:
    rtrn = 1;
}
      EOF
    )
    assert_not_nil(tree)
  
    cases = tree.all(:Case)
    assert_not_nil(cases)
    assert_equal(9, cases.length)

    assert_equal(cases[0].case_op, nil)
    assert_equal(cases[6].case_op.to_s, "=~")

    assert_equal(cases[0].case_val.value, 0)
    assert_equal(cases[4].case_val.text, "^cde.*")
    assert_equal(cases[2].case_val, nil)

    assert_equal(cases[6].case_type, "normal_with_op")
    assert_equal(cases[0].case_type, "normal")
    assert_equal(cases[2].case_type, "default")
    assert_equal(cases[6].case_type, "normal_with_op")

    switches = tree.all(:Switch)
    assert_not_nil(switches)
    assert_equal(3, switches.length)

    assert_equal(switches[1].switch_op.to_s, "=~")
    assert_equal(switches[0].switch_op, nil)

    assert_equal(switches[0].switch_expr.tokens[0].name, "value")
    assert_equal(switches[1].switch_expr.tokens[0].name, "value1")
    assert_equal(switches[2].switch_expr.tokens[0].name, "value2")
  end
end
