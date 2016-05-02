function joints = detect_joints(im, opt)

[joints, heatmap] = applyNet(im, opt);

end