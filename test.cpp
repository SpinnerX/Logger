#include <iostream>
#include <cstring>
#include <map>
#include <queue>
#include <deque>
#include <algorithm>
#include <iterator>
using namespace std;

// Input: nums = [1,1,1,2,2,3], k = 2
// Output: [1,2]


int main() {
    // LIFO DS
    // std::deque<int> arr = {2, 3, 5, 7}; 
    // std::deque<int> vec = {};
    // std::deque<int> arr = {1, 2, 3, 4};
    std::vector<int> vec = {1, 2, 3, 4};
    std::deque<int> arr;

    // std::copy(arr.begin(), arr.end(), std::front_inserter(vec));
    std::copy(vec.begin(), vec.end(), std::front_inserter(arr));

    std::deque<int> left; // constructing our left 
    std::deque<int> right;

    left.push_back(1);

    int temp = 1;

    std::transform(arr.begin(), arr.end(), std::back_inserter(left), [&](int i) { temp *= i; return temp; });

    temp = 1;

    // inserting the right vector items to the front
    std::transform(arr.rbegin(), arr.rend(), std::front_inserter(right), [&](int i) { temp *= i; return temp; });

    right.push_back(1);

    // Using std::transform does an operation and copies that output into the output array
    // left and left.size()-1 * right.begin()+1
    // std::transform(left.begin(), left.end()-1, right.begin()+1, std::ostream_iterator<int>(std::cout, "\t"), [](int i, int j) { return i * j; }); // ostream iterator is how we basically std::cout stuff in a specific order (in simpler terms)
    // std::transform(left.begin(), left.end()-1, right.begin()+1, right.end()); // ostream iterator is how we basically std::cout stuff in a specific order (in simpler terms)
    std::transform(left.begin(), left.end()-1, right.begin()+1, std::front_inserter(vec), [](int i, int j) { return i * j; });
    std::cout << '\n';

    for(auto iter = vec.begin(); iter != vec.end(); iter++){
        std::cout << *iter << ' ';
    }


    std::vector<int> output;

    std::copy(vec.rbegin(), vec.rend(), std::back_inserter(output));
}