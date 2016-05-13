% % testpic = 'dog.jpg';
% % confirm = input('Is this correct? (Enter y for yes or n for no):', 's');
% % if confirm == 'n'
% %     correct_answer = input('What is the correct class for this object?', 's');
% %     target_location = strcat('/Users/Bishwo/Downloads/101_ObjectCategories/',correct_answer);
% %     if exist(target_location, 'file')~=7
% %         mkdir(target_location)
% %         copyfile(testpic, strcat('/Users/Bishwo/Downloads/101_ObjectCategories/', correct_answer));
% %         display('Thank you for your input. Now, please run the program to try again.')
% %     end
% % end
% % confirm = 'y';
% % confirm = 'n';
% % 
% % confirm = 'n';
% % correct_answer = 'dldld';
% % while confirm=='n'
% %     display('hi');
% %     confirm = 'y'
% % end
% %     target_location = strcat('/Users/Bishwo/Downloads/101_ObjectCategories/',correct_answer);
% % isa('hi', 'char')
% 
% imgSets = imageSet(fullfile('/Users/Bishwo/Downloads/101_ObjectCategories'), 'recursive');
% % rootFolder = ('/Users/Bishwo/Downloads/101_ObjectCategories');
% 
% % imgSets = [ imageSet(fullfile(rootFolder, 'airplanes')), ...
% %             imageSet(fullfile(rootFolder, 'cup')), ...
% %             imageSet(fullfile(rootFolder, 'ferry')), ...
% %             imageSet(fullfile(rootFolder, 'dollar_bill')) ...
% %             imageSet(fullfile(rootFolder, 'pyramid')), ...
% %             imageSet(fullfile(rootFolder, 'starfish')) ]; 
% 
% minSetCount = min([imgSets.Count]);
% 
% 
% 
% trainingSets = partition(imgSets, 0.1, 'randomize');
my_dir = '/Users/Bishwo/Downloads/10_object_categories/';
%     correct_answer = input('What is the correct class for this object? ', 's');
% 
%     target_location = strcat(my_dir,correct_answer);
%     display(target_location)

pic = 'dog.jpg';
confirm = input('Is this correct? (Enter y for yes or n for no):', 's');
if confirm == 'n'
    correct_answer = input('What is the correct class for this object? ', 's');
    target_location = strcat(my_dir,correct_answer);
    if exist(target_location, 'file')~=7
        display('asdlkfjalsdjf');
        display(my_dir);
        mkdir(target_location)
        for i=1:3
%             copyfile(pic, [target_location, '_', num2str(i), '.jpg']);
%             copyfile(pic, target_location, ['copy', num2str(i), '.jpg']);
        end
%         copyfile(testpic, strcat('/Users/Bishwo/Downloads/101_ObjectCategories/', correct_answer));
        display('Thank you for your input. Now, please run the program to try again.')
    end
end