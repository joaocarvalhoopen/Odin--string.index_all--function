// Name:        strings.index_all.odin
// Author:      João Carvalho
// Date:        2023.08.13
// Description: This is my first program in the fantastic Odin programming
//              language on Linux.
// License:     MIT Open Source License
//
// To run this program you need to install the Odin compiler and the
// Odin ols plugin in your preferred text editor:
//
// To compile for debug do:
//
//    $ odin build strings.index_all.odin -file -vet -debug
// 
// To compile for release do:
// 
//    $ odin build strings.index_all.odin -file
//
// To run the program do this:
//
//    $ ./strings.index_all
//
// Or do this:
//
//    $ odin run strings.index_all.odin -file
//

package main

import "core:fmt"
import "core:strings"


// index_all() seach for all ocurrencies indexes of a subsstring inside a string
// and it is an extension to the string procedures.
index_all :: proc( string_target: string, sub_str: string, case_sensitive: bool = true) -> (res : [dynamic]int ) {  
    len_s_tmp       := len( string_target )
	len_sub_str_tmp := len( sub_str )  
    if len_s_tmp == 0 || len_sub_str_tmp == 0  {
        return res
    }
    s_tmp       := string_target
	sub_str_tmp := sub_str 
	if !case_sensitive {
		s_tmp       = strings.to_lower( string_target )
		sub_str_tmp = strings.to_lower( sub_str )
        defer delete( s_tmp )
        defer delete( sub_str_tmp )
	}
	slice := s_tmp[ : ]
	// res_tmp : [dynamic]Ocurencies = nil
	accu_index_start := 0
	for { 
        i := strings.index( slice, sub_str_tmp )
        if i < 0 {
            return res
        }
		accu_index_start += i
		accu_index_end := accu_index_start + len_sub_str_tmp  
		// We only create the vector if we have result to return.
        if res == nil do res = make([dynamic]int, 0, 7)

        append( &res, accu_index_start )
		// Prepare slice for next iteration.
		slice = s_tmp[ accu_index_end : ]
        // Update the accu_index_start for the next iteration.
        accu_index_start = accu_index_end 
	}
}


//****************
// Test functions.

TestOutcomes :: enum {
    Success,
    Fail,
}

// The test__index_all() function is a helper function to test the index_all() function.
test__index_all :: proc (test_description: string, string_target: string,
                       sub_str: string, case_sensitive: bool, testOutcome: TestOutcomes ) {
    fmt.printf("\n%v\n", test_description )
    actual_outcome : TestOutcomes;
    index_vec: = index_all( string_target, sub_str, case_sensitive )
    if len( index_vec ) == 0 {
    	fmt.printf("word: \"%v\" - No index found.\n", sub_str)
        actual_outcome = TestOutcomes.Fail
    } else {
        len_sub_str := len( sub_str )
        for word_index_start in index_vec {
            fmt.printf(" word: \"%v\" start: %v end: %v\n", sub_str, word_index_start, word_index_start + len_sub_str )
        }
    
        delete(index_vec)
        actual_outcome = TestOutcomes.Success
    }
    if actual_outcome != testOutcome {
        fmt.printf("==>Test FAILED.\n")
    } else {
        fmt.printf("==>Test SUCCESS.\n")
    }
}

// The test_all__index_all() function is a helper function to run all the tests
// on the index_all() function.
test_all__index_all :: proc () {

    test_description     : string
    string_target        : string
    sub_str              : string 
    case_sensitive       : bool
    expected_test_result : TestOutcomes

    // Test 1
    test_description = "Test 1 - Search the string \"Hello, Hello, Hello!\" for the \"Hello\" sub-string case-sensitive = true."
    string_target    = "Hello, Hello, Hello!"
    sub_str          = "Hello" 
    case_sensitive   = true
    expected_test_result = TestOutcomes.Success
    test__index_all( test_description, string_target, sub_str, case_sensitive, expected_test_result )

    // Test 2
    test_description = "Test 2 - Search the string \"Hello, Hello, Hello!\" for the \"heLLo\" sub-string case-sensitive = false."
    string_target   = "Hello, Hello, Hello!"
    sub_str         = "heLLo" 
    case_sensitive  = false
    expected_test_result = TestOutcomes.Success
    test__index_all( test_description, string_target, sub_str, case_sensitive, expected_test_result )

    // Test 3
    test_description = "Test 3 - Search the string \"Hello, Hello, Hello!\" for the \"bla\" sub-string."
    string_target   = "Hello, Hello, Hello!"
    sub_str         = "bla" 
    case_sensitive  = true
    expected_test_result = TestOutcomes.Fail
    test__index_all( test_description, string_target, sub_str, case_sensitive, expected_test_result )

    // Test 4
    test_description = "Test 4 - Search the string \"Hello, Hello, Hello!\" for the empty sub-string."
    string_target   = "Hello, Hello, Hello!"
    sub_str         = "" 
    case_sensitive  = false
    expected_test_result = TestOutcomes.Fail
    test__index_all( test_description, string_target, sub_str, case_sensitive, expected_test_result )

    // Test 5
    test_description = "Test 5 - Search on a empty string with a empty sub-string."
    string_target   = ""
    sub_str         = "" 
    case_sensitive  = true
    expected_test_result = TestOutcomes.Fail
    test__index_all( test_description, string_target, sub_str, case_sensitive, expected_test_result )

    // Test 6
    test_description = "Test 6 - Search on a empty string with a \"bla\" sub-string."
    string_target   = ""
    sub_str         = "bla" 
    case_sensitive  = true
    expected_test_result = TestOutcomes.Fail
    test__index_all( test_description, string_target, sub_str, case_sensitive, expected_test_result )
}

main :: proc ()  {
    fmt.println("\n Odin - my first program in Odin - strings.index_all() extension to the string procedures\n\n")
 
    test_all__index_all()

    fmt.println("\n\n ...end of tests.\n")
}