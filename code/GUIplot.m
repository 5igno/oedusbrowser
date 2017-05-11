function hndl = GUIplot ( axes , Spectra_structure , id )

hndl = plot(axes,Spectra_structure(id).energy,Spectra_structure(id).intensity);
% A couple fo graphical options are set:
set(hndl,'LineWidth',2);
% linewidth in the graph = 2
ylabel('Intensity'), xlabel('Energy [eV]');

axis tight;

