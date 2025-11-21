// SPDX-License-Identifier: GPL-2.0

#include <linux/usb.h>
#include <linux/input.h>

struct usb_device *rust_helper_interface_to_usbdev(struct usb_interface *intf)
{
	return interface_to_usbdev(intf);
}

void rust_helper_usb_fill_int_urb(struct urb *urb,
				    struct usb_device *dev,
				    unsigned int pipe,
				    void *transfer_buffer,
				    int buffer_length,
				    usb_complete_t complete_fn,
				    void *context,
				    int interval)
{
	usb_fill_int_urb(urb,
		dev,
		pipe,
		transfer_buffer,
		buffer_length,
		complete_fn,
		context,
		interval);
}

void rust_helper_input_report_key(struct input_dev *dev, unsigned int code, int value)
{
	input_report_key(dev, code, value);
}

void rust_helper_input_sync(struct input_dev *dev)
{
	input_sync(dev);
}
