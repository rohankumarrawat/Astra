# yourapp/templatetags/custom_tags.py
from django import template

register = template.Library()

@register.filter
def get_range(start, end):
    return range(start, end)

@register.filter
def make_list(value, max_value):
    return range(1, int(max_value) + 1)
