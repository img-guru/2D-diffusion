close all;
clear all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2D diffusion as described by this tutorial:
% http://nbviewer.jupyter.org/github/barbagroup/CFDPython/blob/master/lesso
% ns/09_Step_7.ipynb
% Step 7 of the CFD 12-step tutorial by Prof. Lorena Barba
% Attempted by Heba A. Shalaby 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nx = 41;
ny = 41;
nt = 300;
c = 1;
dx = 2/(nx-1);
dy = 2/(ny-1);
sigma = 0.2;
dt = sigma*dx*dy/c;

x = linspace(0,2,nx);
y = linspace(0,2,ny);

u = ones(ny,nx);
un = ones(ny,nx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u(0.5/dy:1/dy+1 , 0.5/dx:1/dx+1) = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[X,Y] = meshgrid(x,y);

axis([0 2 0 2 0 2 0 2])

s1 = surf(X,Y,u);                       % plot diffusion in x-direction
title('2D Diffusion');
colormap(jet);
%view(90,70);
view(80,30);
set(gca,'clim',[1 2]);                  % to have colormap change in the whole jet spectrum between the 1 and 2 axis values 
axis([0,2,0,2,0,2]);                    % limit the axis for viewing

opengl('software')
set(gca,'nextplot','replacechildren','visible','off')
f = getframe(gcf);
[im,map] = rgb2ind(f.cdata,jet(256),'nodither');
im(1,1,1,nt) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for t=1:nt
    un = u;
    
    for i=2:nx-1
        for j=2:ny-1
            
            % find u^n+1_(i,j) in x-direction 
            % forward difference in time & backward different in space
            u(i,j) = un(i,j) + c*dt/(dx^2)*(un(i+1,j)-2*un(i,j)+ un(i-1,j)) ...
                             + c*dt/(dy^2)*(un(i,j+1)-2*un(i,j)+ un(i,j-1));
        
            u(1,j) = 1;
            u(i,1) = 1;
            u(nx,j) = 1;
            u(i,ny) = 1;
            
        end
    end
    
    set(s1,'ZData',u);            % update 3D plot animation (x-direction)
    pause(0.001);                 % pause to control animation speed
    %drawnow;
    f = getframe(gcf);
    im(:,:,1,t) = rgb2ind(f.cdata,map,'nodither');
   
  
end

imwrite(im,jet(256),'myDiffusion-test.gif','gif','DelayTime',0,'LoopCount',inf, 'BackgroundColor', 0) %g443800



