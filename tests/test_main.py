from py_module_boilerplate.main import get_message


def test_get_message():
    assert get_message() == 'Hello, world!'
