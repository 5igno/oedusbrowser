function Movie = Showfitraman(Data,fighandle)

[~,N_meas]=size(Data);

figure(fighandle); hold on;

for id_meas=1:N_meas
    N_peaks = Data(id_meas).fit_parameters{2,2}{2,2}(1,1).value;
    Height = Data(id_meas).fit_parameters{2,2}{2,2}(1,2).value;
    Position = Data(id_meas).fit_parameters{2,2}{2,2}(1,3).value;
    Width = Data(id_meas).fit_parameters{2,2}{2,2}(1,4).value;
    
    wavenumbers=Data(id_meas).wavenumbers;
    
    maybeslope = size(Data(id_meas).fit_parameters{2,2}{2,2});
    if maybeslope(1,2)>5
        Slope = Data(id_meas).fit_parameters{2,2}{2,2}(1,5).value;
        Intercept = Data(id_meas).fit_parameters{2,2}{2,2}(1,6).value;
        background=Intercept+Slope*wavenumbers;
    else
        background=0.*wavenumbers;
    end
    
    for id_peak=1:N_peaks
        peak.height = Height(id_peak);
        peak.width = Width(id_peak);
        peak.position = Position(id_peak);
        
        Intensity = Lorentian (wavenumbers,peak) + background;
        
        plot(wavenumbers,Intensity,'k');
    end
    plot(wavenumbers,Data(id_meas).intensity,'o')
    xlim([200 400])
%     ylim([-5 120])
    Movie(id_meas) = getframe;
    clf
    figure(fighandle), hold on;
    
end
clf
movie2avi(Movie, 'test2','compression','MSVC','fps',5)
movie(Movie,5,5)
    
    
    