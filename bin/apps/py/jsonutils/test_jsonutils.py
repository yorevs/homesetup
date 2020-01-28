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
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

SAMPLE_FILE_NAME = "../samples/json_utils_sample.json"


def set_up():
    try:
        with open(SAMPLE_FILE_NAME) as sample_file:
            TestJsonUtils.json_object = json.load(sample_file)
        print('"{}" JSON file has been opened'.format(SAMPLE_FILE_NAME))
    except ValueError:
        print('"{}" JSON file cannot be opened'.format(SAMPLE_FILE_NAME))


class TestJsonUtils(unittest.TestCase):
    json_object = None
    sample_file = None
    j_utils = JsonUtils()

    # TEST CASES ----------

    # TC1 - Test selecting a simple element.
    def test_case_1(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem0')
        self.assertIsNone(st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem1')
        self.assertEqual('value1', st)

    # TC2 - Test selecting a nested element.
    def test_case_2(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem2.elem2_1')
        self.assertEqual('value2_1', st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem2.elem2_3.elem2_3_2')
        self.assertEqual('value2_3_2', st)

    # TC3 - Test selecting an indexed element.
    def test_case_3(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem3[0]')
        self.assertEqual({"name1": "value_name1"}, st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem3[2]')
        self.assertEqual({"name3": [{"inner_name1": "inner_value1"}, {"inner_name1": "inner_value2"}]}, st)

    # TC4 - Test selecting a nested indexed element.
    def test_case_4(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem3[2].name3')
        self.assertEqual([{"inner_name1": "inner_value1"}, {"inner_name1": "inner_value2"}], st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem3[2].name3[0]')
        self.assertEqual({"inner_name1": "inner_value1"}, st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem3[2].name3[0].inner_name1')
        self.assertEqual('inner_value1', st)

    # TC5 - Test selecting a nested element by a property value inside an array.
    def test_case_5(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem5{radio}')
        self.assertEqual('Gaga', st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem5{radio<Gugo>}')
        self.assertEqual('Gugo', st)

    # TC6 - Test selecting a nested property nested inside an array by a property value inside an array.
    def test_case_6(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object,
                                              'elem4{elem4_1}{elem4_1_1}{inner_nested_name1}')
        self.assertEqual('inner_nested_value1_1', st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object,
                                              'elem4{elem4_1}{elem4_1_1}{inner_nested_name1<inner_nested_value2_1>}')
        self.assertEqual('inner_nested_value2_1', st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object,
                                              'elem4{elem4_1}{elem4_1_2}{inner_nested_name1<inner_nested_value4_1>}')
        self.assertEqual('inner_nested_value4_1', st)

    # TC7 - Test selecting mixed nested properties and indexes.
    def test_case_7(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object,
                                              'elem4{elem4_2}[0].elem4_2_1{inner_nested_name1<inner_nested_value2_1>}')
        self.assertEqual('inner_nested_value2_1', st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object,
                                              'elem4{elem4_2}[1].elem4_2_2{inner_nested_name1<inner_nested_value4_1>}')
        self.assertEqual('inner_nested_value4_1', st)

    # TC8 - Test selecting parents.
    def test_case_8(self):
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem6.elem6_1.{elem6_1_1<value6_1_1_B>}',
                                              True)
        self.assertEqual({"elem6_1_1": "value6_1_1_B", "elem6_1_2": "value6_1_2_B",
                          "elem6_1_3": [{"elem6_1_3_1": "value6_1_3_1_B", "elem6_1_3_2": "value6_1_3_2_B"},
                                        {"elem6_1_3_1": "value6_1_3_1_D", "elem6_1_3_2": "value6_1_3_2_D"}]}, st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object, 'elem6.elem6_1.{elem6_1_1<value6_1_1_A>}',
                                              True)
        self.assertEqual({"elem6_1_1": "value6_1_1_A", "elem6_1_2": "value6_1_2_A",
                          "elem6_1_3": [{"elem6_1_3_1": "value6_1_3_1_A", "elem6_1_3_2": "value6_1_3_2_A"},
                                        {"elem6_1_3_1": "value6_1_3_1_C", "elem6_1_3_2": "value6_1_3_2_C"}]}, st)
        st = TestJsonUtils.j_utils.jsonSelect(TestJsonUtils.json_object,
                                              'elem6.elem6_1.{elem6_1_1<value6_1_1_A>}.elem6_1_3{elem6_1_3_1<value6_1_3_1_A>}',
                                              True)
        self.assertEqual({"elem6_1_3_1": "value6_1_3_1_A", "elem6_1_3_2": "value6_1_3_2_A"}, st)


# Program entry point.
if __name__ == '__main__':
    set_up()
    suite = unittest.TestLoader().loadTestsFromTestCase(TestJsonUtils)
    unittest.TextTestRunner(verbosity=2).run(suite)
