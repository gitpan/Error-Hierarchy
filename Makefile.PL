use inc::Module::Install;
name 'Error-Hierarchy';
all_from 'lib/Error/Hierarchy.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'Data::Container';
requires 'Data::Miscellany';
requires 'Data::UUID';
requires 'Error';
requires 'Sys::Hostname';
requires 'Test::Exception';

build_requires 'Test::More';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
