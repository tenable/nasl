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
      public function bar_pub1(foo) {}

      # foo
      function bar_priv_default() { a = 1; return a; }
      private function bar_priv() {}
      function test_bar1(foo) {}

      # foo
      function test_bar()
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
function foo1(){}
      EOF
    )
    assert_not_nil(tree)

    objects = tree.all(:Object)
    assert_equal(1, objects.length)
    assert_equal(objects[0].name.name, "foo")

    functions = tree.all(:Function)
    assert_equal(8, functions.length)

    assert_equal(functions[0].tokens[0].type.to_s, "PUBLIC")
    assert_equal(functions[3].tokens[0].type.to_s, "PRIVATE")

    # private / public object functions, no args
    assert_equal(functions[0].name.name, "bar_pub")
    assert_equal(functions[3].name.name, "bar_priv")

    # private object function without leading attribute, no args
    assert_equal(functions[2].name.name, "bar_priv_default")
    # private object function without leading attribute, args
    assert_equal(functions[4].name.name, "test_bar1")

    # with attribute and args
    assert_equal(functions[1].name.name, "bar_pub1")

    assert_equal(functions[0].fn_type, "obj")
    assert_equal(functions[7].fn_type, "normal")

    obj_vars = tree.all(:ObjVar)
    assert_equal(2, obj_vars.length)
  end

end
