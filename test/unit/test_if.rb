################################################################################
# Copyright (c) 2011, Mak Kolybabi
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

require 'test_helper'

class TestIf < Test::Unit::TestCase

  def test_number
    pass(%q|if (-1);|)
    pass(%q|if (0);|)
    pass(%q|if (1);|)
  end

  def test_assigment
    pass(%q|if (q = 1);|)
  end

  def test_call
    pass(%q|if (foo());|)
  end

  def test_constant
    pass(%q|if (FALSE);|)
    pass(%q|if (NULL);|)
    pass(%q|if (TRUE);|)
  end

  def test_string
    pass(%q|if ('');|)
    pass(%q|if ('foo');|)
    pass(%q|if ("");|)
    pass(%q|if ("foo");|)
  end

  def test_simple
    pass(%q|if (1);|)
    pass(%q|if (1) foo();|)
  end

  def test_compound
    pass(%q|if (1) {}|)
    pass(%q|if (1) {foo();}|)
  end

  def test_nested
    pass(%q|if (1) if (1) foo();|)
    pass(%q|if (1) if (1) {foo();}|)
  end

  def test_dangling
    # This is the correct way to parse the ambiguity presented by the dangling
    # else problem. The else should be attached to the nearest unterminated If.
    same(
      %q|if (1) if (1) foo(); else bar();|,
      '<tree><if><integer value="1"/><if><integer value="1"/><call><identifier name="foo"/></call><call><identifier name="bar"/></call></if></if></tree>'
    )

    diff(
      %q|if (1) if (1) foo(); else bar();|,
      '<tree><if><integer value="1"/><if><integer value="1"/><call><identifier name="foo"/></call></if><call><identifier name="bar"/></call></if></tree>'
    )
  end
end
