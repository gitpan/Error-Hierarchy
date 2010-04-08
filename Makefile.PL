
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Error::Hierarchy',
                       'DISTNAME' => 'Error-Hierarchy',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.31'
                                               },
                       'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>',
                       'BUILD_REQUIRES' => {
                                             'Scalar::Util' => '0',
                                             'Test::More' => '0.94',
                                             'English' => '0',
                                             'File::Find' => '0',
                                             'File::Temp' => '0'
                                           },
                       'ABSTRACT' => 'Support for hierarchical exception classes',
                       'EXE_FILES' => [],
                       'VERSION' => '1.100980',
                       'PREREQ_PM' => {
                                        'Data::Miscellany' => '0',
                                        'YAML' => '0',
                                        'Error' => '0',
                                        'Test::Builder' => '0',
                                        'Data::Inherited' => '0',
                                        'Class::Accessor::Complex' => '0',
                                        'Test::Exception' => '0',
                                        'parent' => '0',
                                        'Data::Container' => '0',
                                        'Data::Dumper' => '0',
                                        'Class::Accessor' => '0',
                                        'overload' => '0',
                                        'constant' => '0',
                                        'Exporter' => '0',
                                        'Data::UUID' => '0',
                                        'Carp' => '0',
                                        'Sys::Hostname' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{BUILD_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.56) };

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



