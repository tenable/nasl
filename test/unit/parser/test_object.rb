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

class TestObject < Test::Unit::TestCase
  include Nasl::Test

  def test_each
    tree = parse(
      <<-EOF
namespace test {
  namespace test_inner {
    object foo {
      var bob = 1;
      var a1,b1;
      # foo
      public function bar_pub() {}
      # foo
      function bar_priv_default() { a = 1; return a; }
      private function bar_priv() {}
      # foo
      function test_var()
      {
        var test = 'a';
        var x,y,z,t;
      }
    }
  }
  # foo!
  function foo(){}
}
# foo!
function foo(){}
      EOF
    )
    assert_not_nil(tree)

    objects = tree.all(:Object)
    assert_equal(1, objects.length)
    assert_equal(objects[0].name.name, "foo")

    functions = tree.all(:Function)
    assert_equal(6, functions.length)

    assert_equal(functions[0].tokens[0].type.to_s, "PUBLIC")
    assert_equal(functions[1].tokens[0], nil)
    assert_equal(functions[2].tokens[0].type.to_s, "PRIVATE")

    obj_vars = tree.all(:ObjVar)
    assert_equal(2, obj_vars.length)
  end

end
