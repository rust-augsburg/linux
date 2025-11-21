// SPDX-License-Identifier: GPL-2.0

#include <linux/usb.h>
#include <linux/input.h>

void *rust_helper_input_get_drvdata(struct input_dev *dev) {
	return input_get_drvdata(dev);
}

void rust_helper_input_set_drvdata(struct input_dev *dev, void *data) {
	input_set_drvdata(dev, data);
}

int rust_helper_usb_rcvintpipe(struct usb_device *dev, int endpoint) {
	return usb_rcvintpipe(dev, endpoint);
}

u16 rust_helper_usb_maxpacket(struct usb_device *udev, int pipe) {
	return usb_maxpacket(udev, pipe);
}

int rust_helper_usb_make_path(struct usb_device *dev, char *buf, size_t size) {
	return usb_make_path(dev, buf, size);
}

void rust_helper_usb_set_intfdata(struct usb_interface *intf, void *data) {
	usb_set_intfdata(intf, data);
}

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
