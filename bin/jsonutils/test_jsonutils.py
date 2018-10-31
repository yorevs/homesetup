import unittest
import json

from JsonUtils import JsonUtils

"""
  @package: jsonutils
   @script: test_JsonUtils.py
  @purpose: Test Suite for JsonUtils.
  @created: Aug 26, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
      Site: https://github.com/yorevs/homesetup
"""

SAMPLE_FILE_NAME = "json_utils_sample.json"


def setUp():
    global JSON_OBJECT
    global sample_file
    global jutils

    JSON_OBJECT = None
    jutils = JsonUtils()

    try:

        with open(SAMPLE_FILE_NAME) as sample_file:
            JSON_OBJECT = json.load(sample_file)

    except ValueError:
        print '%s JSON file is not valid' % SAMPLE_FILE_NAME


def tearDown():
    sample_file.close()


class TestJsonUtils(unittest.TestCase):

    ######## TEST CASES #######

    # TC1 - Test selecting a simple element.
    def test_case_1(self):

        st = jutils.jsonSelect(jsonObject, 'elem0')
        self.assertIsNone(st)
        st = jutils.jsonSelect(jsonObject, 'elem1')
        self.assertEqual(st, 'value1')


    # TC2 - Test selecting a nested element.
    def test_case_2(self):

        st = jutils.jsonSelect(jsonObject, 'elem2.elem2_1')
        self.assertEqual(st, 'value2_1')
        st = jutils.jsonSelect(jsonObject, 'elem2.elem2_3.elem2_3_2')
        self.assertEqual(st, 'value2_3_2')


    # TC3 - Test selecting an indexed element.
    def test_case_3(self):

        st = jutils.jsonSelect(jsonObject, 'elem3[0]')
        self.assertEqual( st, { "name1" : "value_name1" } )
        st = jutils.jsonSelect(jsonObject, 'elem3[2]')
        self.assertEqual(st, { "name3" : [ { "inner_name1" : "inner_value1" }, { "inner_name1" : "inner_value2" } ]})


    # TC4 - Test selecting a nested indexed element.
    def test_case_4(self):

        st = jutils.jsonSelect(jsonObject, 'elem3[2].name3')
        self.assertEqual( st, [ { "inner_name1" : "inner_value1" }, { "inner_name1" : "inner_value2" } ] )
        st = jutils.jsonSelect(jsonObject, 'elem3[2].name3[0]')
        self.assertEqual( st, { "inner_name1" : "inner_value1" } )
        st = jutils.jsonSelect(jsonObject, 'elem3[2].name3[0].inner_name1')
        self.assertEqual( st, 'inner_value1' )


    # TC5 - Test selecting a nested element by a property value inside an array.
    def test_case_5(self):

        st = jutils.jsonSelect(jsonObject, 'elem5{radio}')
        self.assertEqual(st, 'Gaga' )
        st = jutils.jsonSelect(jsonObject, 'elem5{radio<Gugo>}')
        self.assertEqual(st, 'Gugo' )


    # TC6 - Test selecting a nested property nested inside an array by a property value inside an array.
    def test_case_6(self):

        st = jutils.jsonSelect(jsonObject, 'elem4{elem4_1}{elem4_1_1}{inner_nested_name1}')
        self.assertEqual(st, 'inner_nested_value1_1' )
        st = jutils.jsonSelect(jsonObject, 'elem4{elem4_1}{elem4_1_1}{inner_nested_name1<inner_nested_value2_1>}')
        self.assertEqual(st, 'inner_nested_value2_1')
        st = jutils.jsonSelect(jsonObject, 'elem4{elem4_1}{elem4_1_2}{inner_nested_name1<inner_nested_value4_1>}')
        self.assertEqual(st, 'inner_nested_value4_1')


    # TC7 - Test selecting mixed nested properties and indexes.
    def test_case_7(self):

        st = jutils.jsonSelect(jsonObject, 'elem4{elem4_2}[0].elem4_2_1{inner_nested_name1<inner_nested_value2_1>}')
        self.assertEqual(st, 'inner_nested_value2_1' )
        st = jutils.jsonSelect(jsonObject, 'elem4{elem4_2}[1].elem4_2_2{inner_nested_name1<inner_nested_value4_1>}')
        self.assertEqual(st, 'inner_nested_value4_1' )


    # TC8 - Test selecting parents.
    def test_case_8(self):

        st = jutils.jsonSelect(jsonObject, 'elem6.elem6_1.{elem6_1_1<value6_1_1_B>}', True)
        self.assertEqual(st, { "elem6_1_1": "value6_1_1_B", "elem6_1_2": "value6_1_2_B", "elem6_1_3": [{ "elem6_1_3_1" : "value6_1_3_1_B", "elem6_1_3_2" : "value6_1_3_2_B" }, { "elem6_1_3_1" : "value6_1_3_1_D", "elem6_1_3_2" : "value6_1_3_2_D" }] } )
        st = jutils.jsonSelect(jsonObject, 'elem6.elem6_1.{elem6_1_1<value6_1_1_A>}', True)
        self.assertEqual(st, { "elem6_1_1": "value6_1_1_A", "elem6_1_2": "value6_1_2_A", "elem6_1_3": [{ "elem6_1_3_1" : "value6_1_3_1_A", "elem6_1_3_2" : "value6_1_3_2_A" }, { "elem6_1_3_1" : "value6_1_3_1_C", "elem6_1_3_2" : "value6_1_3_2_C" }] } )
        st = jutils.jsonSelect(jsonObject, 'elem6.elem6_1.{elem6_1_1<value6_1_1_A>}.elem6_1_3{elem6_1_3_1<value6_1_3_1_A>}', True)
        self.assertEqual(st, { "elem6_1_3_1" : "value6_1_3_1_A", "elem6_1_3_2" : "value6_1_3_2_A" } )


# Program entry point.
if __name__ == '__main__':
    setUp()
    suite = unittest.TestLoader().loadTestsFromTestCase(TestJsonUtils)
    unittest.TextTestRunner(verbosity=2).run(suite)
    tearDown()
