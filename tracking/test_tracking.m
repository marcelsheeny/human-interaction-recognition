clc;
close all;
clear all;

%addpath(genpath('../../libs/dctracking/'));

%[metrics2d, metrics3d, allen, stateInfo, sceneInfo] = ...
%    swDCTracker('example.ini','default2dSimple.ini');

obj = setupSystemObjects();

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
for i=1:(obj.reader.Duration*obj.reader.FrameRate)
    obj.reader.CurrentTime = i/obj.reader.FrameRate;
    frame = readFrame(obj.reader);
    [centroids, bboxes] = detectObjects(obj,i);
    tracks = predictNewLocationsOfTracks(tracks);
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks,centroids);

    tracks = updateAssignedTracks(assignments,centroids,bboxes,tracks);
    tracks = updateUnassignedTracks(unassignedTracks,tracks);
    tracks = deleteLostTracks(tracks);
    tracks = createNewTracks(tracks,centroids,bboxes,nextId,unassignedDetections);

    displayTrackingResults(obj,frame,tracks,bboxes);
end