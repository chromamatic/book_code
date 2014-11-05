#---
# Excerpted from "Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rr2 for more book information.
#---
require File.dirname(__FILE__) + '/../abstract_unit'

class JavaScriptHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::JavaScriptHelper
  
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  
  def test_define_javascript_functions
    # check if prototype.js is included first
    assert_not_nil define_javascript_functions.split("\n")[1].match(/Prototype JavaScript framework/)
    
    # check that scriptaculous.js is not in here, only needed if loaded remotely
    assert_nil define_javascript_functions.split("\n")[1].match(/var Scriptaculous = \{/)
  end

  def test_escape_javascript
    assert_equal %(This \\"thing\\" is really\\n netos\\'), escape_javascript(%(This "thing" is really\n netos'))
  end
                                      
  def test_link_to_function
    assert_dom_equal %(<a href="#" onclick="alert('Hello world!'); return false;">Greeting</a>), 
      link_to_function("Greeting", "alert('Hello world!')")
  end
  
  def test_link_to_function_with_existing_onclick
    assert_dom_equal %(<a href="#" onclick="confirm('Sanity!'); alert('Hello world!'); return false;">Greeting</a>), 
      link_to_function("Greeting", "alert('Hello world!')", :onclick => "confirm('Sanity!')")
  end

  def test_link_to_function_with_rjs_block
    html = link_to_function( "Greet me!" ) do |page|
      page.replace_html 'header', "<h1>Greetings</h1>"
    end
    assert_dom_equal %(<a href="#" onclick="Element.update(&quot;header&quot;, &quot;&lt;h1&gt;Greetings&lt;/h1&gt;&quot;);; return false;">Greet me!</a>), html
  end


  def test_button_to_function
    assert_dom_equal %(<input type="button" onclick="alert('Hello world!');" value="Greeting" />), 
      button_to_function("Greeting", "alert('Hello world!')")
  end

  def test_button_to_function_with_rjs_block
    html = button_to_function( "Greet me!" ) do |page|
      page.replace_html 'header', "<h1>Greetings</h1>"
    end
    assert_dom_equal %(<input type="button" onclick="Element.update(&quot;header&quot;, &quot;&lt;h1&gt;Greetings&lt;/h1&gt;&quot;);;" value="Greet me!" />), html
  end
end