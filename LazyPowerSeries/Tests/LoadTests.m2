
loadTests = method()
loadTests(String) := TestPath ->(
    TestPaths = findFiles(TestPath, FollowLinks=>true);
    TestFilePaths = select(TestPaths, i->match(".*\\.m2$",i));
    
    for filepath in TestFilePaths do(
        realfilepath = realpath filepath;
        print realfilepath;
        load realfilepath;
    ); 
);

TestPaths = {
    concatenate(currentFileDirectory,"LazySeries")
    --concatenate(currentFileDirectory,"Padics")
}

load "./TestingHelperFunctions.m2";
for testpath in TestPaths do loadTests(testpath)