void dummy_test_entrypoint() {}

void main() 
{
    *(char*) 0x0b8000 = 'X';
    return;
}