#include <boost/system/error_code.hpp>
#include <iostream>

int main( void )
{
    std::cout << "Hello!" << std::endl;
    boost::system::error_code e( boost::system::errc::bad_message, boost::system::generic_category() );
    std::cout << e << std::endl;
}
