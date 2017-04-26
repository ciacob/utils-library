package ro.ciacob.utils.tests
{
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertEquals;
	
	import ro.ciacob.utils.Arrays;
	
	public class ArraysTests {
		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass() : void {
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testConsolidate():void
		{
			// Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testDeepCloneArrayOfBasicTypes():void
		{
			// Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testFilterObjectsArray() : void {
			var source : Array;
			var condition : Object;
			var expectedValue : Array;
			var result : Array;
			
			// Test 1 (simple condition, no flags)
			source = [
				{ name : "red", hex : 0xff0000 },
				{ name : "green", hex : 0x00ff00 },
				{ name : "blue", hex : 0x0000ff },
				{ name : "gray", hex : 0xcccccc }
			]
			condition = {name: "red"};
			expectedValue = [
				{ name : "red", hex : 0xff0000 }
			];
			result = Arrays.filterObjectsArray (source, condition);
			assertEquals ("Test 1 failed (simple condition, no flags).\n",
				JSON.stringify (expectedValue), JSON.stringify (result));
			
			// Test 2 (complex condition/alternative values, no flags)
			condition = {name: ["red", "green"]};
			expectedValue = [
				{ name : "red", hex : 0xff0000 },
				{ name : "green", hex : 0x00ff00 }
			];
			result = Arrays.filterObjectsArray (source, condition);
			assertEquals ("Test 2 failed (complex condition/alternative values, no flags).\n",
				JSON.stringify (expectedValue), JSON.stringify (result));
			
			// TEST 3 (simple condition, `Arrays.FILTER_SUBSTRING` flag)
			condition = {name: "gr"};
			expectedValue = [
				{ name : "green", hex : 0x00ff00 },
				{ name : "gray", hex : 0xcccccc }
			];
			result = Arrays.filterObjectsArray (source, condition, Arrays.FILTER_SUBSTRING);
			assertEquals ("Test 3 failed (simple condition, `Arrays.FILTER_SUBSTRING` flag).\n",
				JSON.stringify (expectedValue), JSON.stringify (result));
			
			// TODO: add more tests, to cover all the flags and their combination; maybe move
			// the testing for the `filterObjectsArray()` method to a dedicated Test Case class,
			// since it is rather complex
		}
		
		[Test]
		public function testGetRandomItem():void
		{
			// Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testGetSubsetOf():void
		{
			// Assert.fail("Test method Not yet implemented");
		}
		
		[Test (description="Tests `intersect()` with `noDupplicates` set to true.")]
		public function testIntersect() : void {
			var blueObj : Object = {blue : 0x0000ff};
			var purpleObj : Object = {purple : 0xff00ff};
			var a : Array = ['red', 'green', 'blue', 'orange', {red : 0xff0000}, {green : 0x00ff00}, blueObj, purpleObj ];
			var b : Array = ['orange', 'yellow', 'green', 'orange', {red : 0xff0000}, blueObj];
			var expectedResult : Array = [blueObj, 'green', 'orange'];
			var result : Array = Arrays.intersect (a, b, true);
			assertEquals (JSON.stringify (expectedResult), JSON.stringify(result));
		}
		
		[Test(description="Tests `removeDuplicates()`.")]
		public function testRemoveDuplicates ():void {
			var blueObj : Object = {blue : 0x0000ff};
			var purpleObj : Object = {purple : 0xff00ff}
			var _mixedArrayWithDupplicates : Array = _mixedArrayWithDupplicates = [
				'gigi', 'gigel', 'mumunel', 'gigi', true, 'miau', 'mumunel', 3, true, false,
				{red: 0xff0000}, {green: 0x00ff00}, {red: 0xff0000}, // `RED`: identical Objects, separate instances
				blueObj, purpleObj, blueObj // `BLUE`: same instance, twice
			];
			var _mixedArrayWithoutDupplicates : Array = _mixedArrayWithoutDupplicates = [
				'gigi', 'gigel', 'mumunel', true, 'miau', 3, false,
				{red: 0xff0000}, {green: 0x00ff00}, // No dupplicate objects, whether they share the same instance or not.
				blueObj, purpleObj
			];
			var filteredArray : Array = _mixedArrayWithDupplicates.concat();
			Arrays.removeDuplicates (filteredArray);
			assertEquals (JSON.stringify(_mixedArrayWithoutDupplicates), JSON.stringify(filteredArray));
		}
		
		[Test]
		public function testShuffle():void
		{
			// Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testSortAndTestForIdenticPrimitives():void
		{
			// Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testTestForIdentity():void
		{
			// Assert.fail("Test method Not yet implemented");
		}
	}
}