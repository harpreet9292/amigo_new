import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/views/flex_forms/FlexFieldLabel.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/ImagesFieldModel.dart';
import 'package:amigotools/views/shared/ModalDialog.dart';
import 'package:amigotools/views/flex_forms/FlexFieldValidationMsg.dart';
import 'package:dotted_border/dotted_border.dart';

class ImagesField extends FlexFieldBase {
  ImagesField({required bool editMode}) : super(editMode: editMode);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<FlexFieldModel>() as ImagesFieldModel;

    final size = MediaQuery.of(context).size;
    final fullwidth = size.width;
    final width = size.width * 0.14;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlexFieldLabel(model.label, model.required),
          Container(
            padding: const EdgeInsets.all(4.0),
            width: fullwidth,
            decoration: BoxDecoration(
              border: Border.all(
                color: model.displayErrorMessage != null
                    ? GeneralConfig.palette2SupportingRed700
                    : GeneralConfig.palette2Neutrals200,
              ),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: Wrap(
              spacing: 8.0, // gap between adjacent items
              runSpacing: 8.0, // gap between lines
              children: _createItemsList(context, model, width).toList(),
            ),
          ),
          FlexFieldValidationMsg(textOrHide: model.displayErrorMessage),
        ],
      ),
    );
  }

  Iterable<Widget> _createItemsList(
      BuildContext context, ImagesFieldModel model, double width) sync* {
    for (final file in model.files) {
      yield _createImageItem(context, file, model, width);
    }

    if (editMode) yield _createAddImageItem(context, model, width);
  }

  Widget _createImageItem(BuildContext context, ImagesFieldFileModel file,
      ImagesFieldModel model, double width) {
    return GestureDetector(
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          boxShadow: [
            BoxShadow(
              color: GeneralConfig.palette2Neutrals100,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(file.file),
          ),
        ),
      ),
      onTap: () => showImageDialog(context, file, model),
    );
  }

  Widget _createAddImageItem(
      BuildContext context, ImagesFieldModel model, double width) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: width, height: width),
      child: DottedBorder(
        color: GeneralConfig.palette2Neutrals200,
        strokeWidth: 1,
        dashPattern: [5, 3],
        child: OutlinedButton(
          onPressed: () => model.addImageFromCamera(),
          onLongPress: () => model.addImageFromGallery(),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                return GeneralConfig
                    .palette2Neutrals0; // Use the component's default.
              },
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                style: BorderStyle.none,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                      width: 15,
                      height: 15,
                      margin: EdgeInsets.only(right: 2.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: GeneralConfig.palette2Neutrals200,
                              border: Border.all(
                                color: GeneralConfig.palette2Neutrals200,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ))),
                  Expanded(
                      child: Text(
                    "photo",
                    style: TextStyle(
                      fontSize: 8,
                      color: GeneralConfig.palette2Neutrals200,
                    ),
                  ))
                ],
              ),
              SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 15,
                      height: 15,
                      margin: EdgeInsets.only(right: 2.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: GeneralConfig.palette2Neutrals200,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.radio_button_checked_outlined,
                        color: GeneralConfig.palette2Neutrals200,
                        size: 12,
                      )),
                  Expanded(
                      child: Text(
                    "gallery",
                    style: TextStyle(
                      fontSize: 8,
                      color: GeneralConfig.palette2Neutrals200,
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showImageDialog(
      BuildContext context, ImagesFieldFileModel file, ImagesFieldModel model) {
    showModalDialog(
      context: context,
      title: model.label,
      actions: editMode
          ? [
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  model.deleteImage(file);
                  Navigator.pop(context);
                },
              ),
            ]
          : null,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: GeneralConfig.palette2Neutrals100.withOpacity(0.6),
                blurRadius: 2, // soften the shadow
                spreadRadius: 0.5, //extend the shadow
                offset: Offset(
                  0.2, // Move to right horizontally
                  1, // Move to bottom Vertically
                ),
              )
            ],
          ),
          child: Image.file(file.file, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
