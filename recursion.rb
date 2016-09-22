# Warmup
#
# Write a recursive method, range, that takes a start and an end and
# returns an array of all numbers between. If end < start, you can return the empty array.
# Write both a recursive and iterative version of sum of an array.

# require 'byebug'

def recursion_range(min, max)
  return [] if max < min
  return [max] if min == max
    (recursion_range(min + 1, max)).unshift(min)
    #recursion_range(min+1, max) = complete array from (min, max -1 )
end

def iterative_range(min, max)
  (min..max).to_a
end


# this is math, not Ruby methods.

# # recursion 1
# exp(b, 0) = 1
# exp(b, n) = b * exp(b, n - 1)
#
# # recursion 2
# exp(b, 0) = 1
# exp(b, 1) = b
# exp(b, n) = exp(b, n / 2) ** 2             [for even n]
# exp(b, n) = b * (exp(b, (n - 1) / 2) ** 2) [for odd n]



def simple_expo(base, exp)
  return 1 if exp == 0
  base*simple_expo(base, exp-1)
end


def complex_expo(base, exp)
  return 1 if exp == 0

  if exp.even?
    expo_half = complex_expo(base, exp/2)
    expo_half * expo_half
  else
    expo_half = complex_expo(base, (exp-1)/2)
    base * expo_half * expo_half
  end

end

  def deep_dup(array)
    duped = array.map do |ele|
      if ele.is_a?(Array)
        deep_dup(ele)
      else
        ele
      end
    end

    p array.object_id
    p duped.object_id
  end

  # array1 = [1, [2], [3, [4]]]
  # array2 = deep_dup(array1)


  def dup_check(array1, array2)
    # debugger
    if array1.size == 0
      return "test over "
    end
    if array1[0].is_a?(Array)
      puts array1[0].object_id == array2[0].object_id
      dup_check(array1[0], array2[0])
    else puts array1[0].object_id == array2[0].object_id
      dup_check(array1[1..-1], array2[1..-1])
    end
  end

  def recur_fibonacci(n)
    return [1] if n == 1
    return [1,1] if n == 2
    prev_fib = recur_fibonacci(n-1)
    prev_fib << prev_fib[-1] + prev_fib[-2]
  end

  def iter_fibonacci(n)
    arr = Array.new(n, 1)
    arr.each_with_index do |n, idx|
      next if idx == 0 || idx == 1
      arr[idx] = arr[idx-1] + arr[idx-2]
    end
    arr
  end

  def bsearch(array,target)
    return nil if !array.include?(target)
    return 0 if array.size == 1
    mid_idx = (array.size / 2)

    if target > array[mid_idx]
      bsearch(array[mid_idx..-1], target) + mid_idx
    elsif target < array[mid_idx]
      bsearch(array[0..mid_idx-1], target)
    else
      return mid_idx
    end
  end

# Merge Sort
#
# Implement a method merge_sort that sorts an Array:
#
# The base cases are for arrays of length zero or one. Do not use a length-two array as a base case.
# This is unnecessary.
# You'll want to write a merge helper method to merge the sorted halves.
# To get a visual idea of how merge sort works, watch this gif and check out this diagram.

  def merge_sort(full_arr)
    return [] if full_arr.size == 0
    return full_arr if full_arr.size == 1
    mid_idx = (full_arr.size / 2)
    first_half = full_arr[0...mid_idx]
    second_half = full_arr[mid_idx..-1]
    merge(merge_sort(first_half), merge_sort(second_half))
  end

  def merge(arr1, arr2)
    return arr2 if arr1.empty?
    return arr1 if arr2.empty?
    if arr1.first < arr2.first
      [arr1.first] + merge(arr1[1..-1],arr2)
    else
      [arr2.first] + merge(arr1, arr2[1..-1])
    end
  end

  #        ((left.first < right.first) ? left.shift : right.shift)
  # Ternary operator

# require 'byebug'
def subsets(array)
  return [[]] if array.empty?
  smaller_subset = subsets(array[0..-2]) #[1,2]
  smaller_subset + smaller_subset.map {|sub| sub += [array[-1]]}
end

 require 'byebug'

 # GREEDY MAKE CHANGE
 # First, write a 'greedy' version called greedy_make_change:
 #
 # Take as many of the biggest coin as possible and add them to your result.
 # Add to the result by recursively calling your method on the remaining amount,
 #  leaving out the biggest coin, until the remainder is zero.

def greedy_make_change(target, coin_types)
  return [] if target == 0
  result = accountant(target,coin_types)
  result[0] + greedy_make_change(result[1], coin_types)
end

def accountant(target, coin_types)
  change = []
  remainder = 0
  coin_types.each do |denom|
    next if target/denom == 0
    num_coins = target / denom
    remainder = target % denom
    change = Array.new(num_coins){denom}
    break
  end
  [change, remainder]
end

def make_better_change(target, coin_types)
  return [] if target == 0

  predictions = {}
  coin_types.each do |coin_taken|
    next if target < coin_taken
    remaining_change = target - coin_taken
    total_coin_predicted = 1

    coin_types.each do |denom|
      total_coin_predicted += remaining_change/denom
      remaining_change %= denom
    end

    predictions[coin_taken] = total_coin_predicted
  end

  reading = predictions.min_by{|key, value| value}[0]

  [reading] + make_better_change(target-reading, coin_types)
end



def psychic(change, coin_types) #output the best single coin to take (first one out of potentially many)
  predictions = {}

  coin_types.each do |coin_taken|
    next if change < coin_taken
    remaining_change = change - coin_taken
    total_coin_predicted = 1

    coin_types.each do |denom2|
      total_coin_predicted += remaining_change/denom2
      remaining_change %= denom2
    end

    predictions[coin_taken] = total_coin_predicted
  end

  predictions
end

def dp_make_change(a, list = [25, 10, 5, 1])
    return nil if a < 0
    return nil if a != a.floor

    parents = Array.new(a + 1)
    parents[0] = 0
    worklist = [[0, 0]]
    while parents[a].nil? && !worklist.empty? do
      base, starting_index = worklist.shift
      starting_index.upto(list.size - 1) do |index|
        coin = list[index]
        tot = base + coin
        if tot <= a && parents[tot].nil?
          parents[tot] = base
          worklist << [tot, index]
        end
      end
    end

    return nil if parents[a].nil?
    result = []
    while a > 0 do
      parent = parents[a]
      result << a - parent
      a = parent
    end
    result.sort!.reverse!
   end

   def aa_make_change(target, coins = [25, 10, 5, 1])
     # Don't need any coins to make 0 cents change
     return [] if target == 0
     # Can't make change if all the coins are too big. This is in case
     # the coins are so weird that there isn't a 1 cent piece.
     return nil if coins.none? { |coin| coin <= target }

     # Optimization: make sure coins are always sorted descending in
     # size. We'll see why later.
     coins = coins.sort.reverse

     best_change = nil
     coins.each_with_index do |coin, index|
       # can't use this coin, it's too big
       next if coin > target

       # use this coin
       remainder = target - coin

       # Find the best way to make change with the remainder (recursive
       # call). Why `coins.drop(index)`? This is an optimization. Because
       # we want to avoid double counting; imagine two ways to make
       # change for 6 cents:
       #   (1) first use a nickel, then a penny
       #   (2) first use a penny, then a nickel
       # To avoid double counting, we should require that we use *larger
       # coins first*. This is what `coins.drop(index)` enforces; if we
       # use a smaller coin, we can never go back to using larger coins
       # later.
       best_remainder = aa_make_change(remainder, coins.drop(index))

       # We may not be able to make the remaining amount of change (e.g.,
       # if coins doesn't have a 1cent piece), in which case we shouldn't
       # use this coin.
       next if best_remainder.nil?

       # Otherwise, the best way to make the change **using this coin**,
       # is the best way to make the remainder, plus this one coin.
       this_change = [coin] + best_remainder

       # Is this better than anything we've seen so far?
       if (best_change.nil? || (this_change.count < best_change.count))
         best_change = this_change
       end
     end

     best_change
   end




coins = [25,10,5,1]
target = 13333



start = Time.now
result1 = make_better_change(target, coins)
finish = Time.now
diff1 = finish - start

start = Time.now
result2 = dp_make_change(target, coins)
finish = Time.now
diff2 = finish - start

start = Time.now
# result3 = aa_make_change(target, coins)
finish = Time.now
# diff3 = finish - start

p "D/S: #{diff1}"
# p "result: #{result1}"
p "Solution: #{diff2}"
# p "result2: #{result2}"
# p "aA: #{diff3}"

500.times do |target|
  something = make_better_change(target+1, [10, 7, 1]).sort == dp_make_change(target+1, [10,7,1]).sort
  print "wrong!" if something == false
  puts target+1 if something == false
end
