
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Error::Hierarchy',
                       'DISTNAME' => 'Error-Hierarchy',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'Support for hierarchical exception classes',
                       'EXE_FILES' => [],
                       'VERSION' => '1.100850',
                       'PREREQ_PM' => {
                                        'Scalar::Util' => '0',
                                        'YAML' => '0',
                                        'Data::Miscellany' => '0',
                                        'Error' => '0',
                                        'File::Find' => '0',
                                        'Test::Builder' => '0',
                                        'Data::Inherited' => '0',
                                        'Class::Accessor::Complex' => '0',
                                        'English' => '0',
                                        'parent' => '0',
                                        'Test::Exception' => '0',
                                        'Data::Dumper' => '0',
                                        'Data::Container' => '0',
                                        'Class::Accessor' => '0',
                                        'overload' => '0',
                                        'constant' => '0',
                                        'Exporter' => '0',
                                        'Data::UUID' => '0',
                                        'Carp' => '0',
                                        'Test::More' => '0.88',
                                        'File::Temp' => '0',
                                        'Sys::Hostname' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



